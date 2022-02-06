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
    private var mode: String?;
    public var target: String?

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("mkdir filter start element")
        spec?.prefix = prefix
        spec?.localname = localName
        commandName = "mkdir"
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    public override func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(command == commandName) {
            let localname = getElement(fullElement: element!).localName
            switch(localname) {
            case "param":
                processParameters(characters: string)
                break;
            case "flag":
                processFlag(characters: string)
                break;
            case "target":
                target = string
                break
            default:
                print("unhandled element.")
            }
        } else {
            super.parser(parser, foundCharacters: string)
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let element = getElement(fullElement: elementName)
        if(element.localName == localName && command == commandName) {
            let params = parameters
            var flags = flags
            if let mode = mode {
                flags.append(modeFlags[0])
                flags.append(mode)
            }
            let result = launchCommand()

            // Check directory exists as belts and braces.
            var successMessage = ""
            if (directory != nil && checkDirectoryExists(path: directory!)) {
                successMessage += "Created directory \(target) in \(directory) (perm: ="
            } else {
                successMessage += "Created directory \(target) (perm: ="
            }

            if let mode = mode {
                successMessage += mode
            } else {
                successMessage += "default"
            }

            successMessage += ")"

            commandMessage(command: commandName!, success: successMessage, result: result)
        }
    }

    func checkDirectoryExists(path: String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            return true
        }
        return false
    }

    func processParameters(characters: String) {
        let clean = characters.trimmingCharacters(in: NSCharacterSet.controlCharacters)
        let things = clean.split(using: #"m/([\*\+\.\w=\/-]+|'[^']+')\s*/g"#.r)
        things.forEach{ item in
            if(!item.isEmpty) {
                parameters.append(item)
            }
        }
    }

    func processFlag(characters: String) {
        if attributes!["Value"] != nil {
            if(modeFlags.contains(characters)) {
                mode = characters
            } else {
                flags = characters.split(using: #"/\s+/"#.r)
            }
        }
    }
}
