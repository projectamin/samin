import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

// This is reflective of Amin::Elt - just found the original naming confusing.
class AminCommandBase: XmlSaxBase {

    var directory: String?
    var target: String?
    var flags = [String]()
    var source = [String]()
    var parameters = [String]()
    var command: String?
    // TODO not sure this is needed.
    var commandName: String?
    var attributes: [String: String] = [:]
    var environmentVariables: [String: String] = [:]
    // TODO making an assumption here that this should be immutable.
    // TODO amin:command filter is only ever dealing with amin:command based elements?
    // TODO Perl implementation had the ability for command filters to override.
    // TODO Here we just sandwich 'prefix' and 'localname'
    var localName = "amin:command"
    var element: String?

    // Regexp used during parsing.
    let paramRegex = "([\\*\\+\\.\\w=\\/-]+|'[^']+')\\s*"

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("AminCommandBase start element")
        print(elementName)
        print(namespaceURI)
        print(qName)
        if(elementName == localName) {
            if(attributeDict.keys.contains("name")) {
                command = attributeDict["name"]
            }
            print(attributeDict)
        }
        element = elementName
        attributes = attributeDict
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }


    func commandMessage() {
        // TODO Dumps success message  / OUT / Error to Log.
    }

    func launchCommand() {

        // TODO Support debug.

        let task = Process()

        let messagePipe = Pipe()
        let outHandle = messagePipe.fileHandleForReading

        outHandle.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: .utf8) {
                // Define the placeholder as public, otherwise the Console obfuscate it
                // TODO Amin log should be passed or accessible elsewhere not directly referenced
                // TODO as it is an implemented interface.
                AminLogStandard.shared.aminOut(message: line)
            }
        }

        let errorPipe = Pipe()
        let errorHandle = errorPipe.fileHandleForReading
        errorHandle.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: .utf8) {
                AminLogStandard.shared.aminError(message: line)
            }
        }

        task.launchPath = command
        task.arguments = parameters
        //task.environment = environmentVariables
        task.standardError = errorHandle
        task.standardOutput = outHandle
    }

    func charactersShell(data: String) {
        if(element == "amin:shell") {
            directory = data
        }
        if(element == "amin:env") {
            // TODO environmentVariables = data
        }
    }
}
