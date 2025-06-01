import Foundation
import Regex

#if canImport(FoundationXML)
    import FoundationXML
#endif

class AminCommandMkdir: AminCommandBase {

    private let modeFlags = ["mode", "m"]

    // Used to replicate Perl tracking current element via spec..
    private let prefix = "amin"
    private let localName = "command"
    private var mode: String?
    public var target: String?

    public override func parser(
        _ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?, attributes attributeDict: [String: String]
    ) {
        spec?.prefix = prefix
        spec?.localname = localName
        commandName = "mkdir"
        super.parser(
            _: parser, didStartElement: elementName, namespaceURI: namespaceURI,
            qualifiedName: qName, attributes: attributeDict)
    }

    public override func parser(_ parser: XMLParser, foundCharacters string: String) {

        if command == commandName
            && !string.replacingOccurrences(
                of: "^\\s*", with: "", options: .regularExpression
            ).isEmpty
        {
            let localname = getElement(fullElement: element!).localName
            switch localname {
            case "param":
                processParameters(characters: string)
                break
            case "flag":
                processFlag(characters: string)
                break
            default:
                // Make sure we default to firing up the chain
                break
            }
        }
        super.parser(parser, foundCharacters: string)
    }

    override func parser(
        _ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        let element = getElement(fullElement: elementName)
        if element.localName == localName && command == commandName {
            if let mode = self.mode {
                parameters.append("mode=\(mode)")
            }

            let result = launchCommand()

            // Check directory exists as belts and braces.
            var successMessage = ""
            if directory != nil && checkDirectoryExists(path: directory!) {
                successMessage +=
                    "Created directory \(String(describing: self.target)) in \(String(describing: directory)) (perm: ="
            } else {
                successMessage += "Created directory \(String(describing: self.target)) (perm: ="
            }

            if let mode = mode {
                successMessage += mode
            } else {
                successMessage += "default"
            }

            successMessage += ")"

            if result.type == .out { result.status = 0 }

            commandMessage(command: commandName!, success: successMessage, result: result)
        }

        super.parser(
            _: parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }

    func checkDirectoryExists(path: String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            return true
        }
        return false
    }

    func processFlag(characters: String) {
        let trimmed = characters.replacingOccurrences(
            of: "^\\s*", with: "", options: .regularExpression)
        if let name = self.attributes?["name"] {
            if modeFlags.contains(name) && !name.isEmpty {
                mode = trimmed
            }
            return
        }

        // Allows defining flags as single XML element or not.
        if !trimmed.isEmpty {
            flags.append(contentsOf: trimmed.map { String($0) })
        }
    }

    func processParameters(characters: String) {
        let clean = characters.trimmingCharacters(in: NSCharacterSet.controlCharacters)
        if let name = self.attributes?["name"] {
            if name == "target" {
                self.target = clean
                return
            }
        }
        let things = clean.split(using: #"m/([\*\+\.\w=\/-]+|'[^']+')\s*/g"#.r)
        things.forEach { item in
            if !item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                parameters.append(item)
            }
        }
    }
}
