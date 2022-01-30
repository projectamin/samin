import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

// This is reflective of Amin::Elt - just found the original naming confusing.
class AminCommandBase: XmlSaxBase {

    public var directory: String?
    public var target: String?
    public var flags = [String]()
    public var source = [String]()
    public var parameters = [String]()
    public var command: String?
    public var commandName: String?
    public var attributes: String?
    public var environmentVariables = [String: String]()
    public var element: String?

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("AminCommandBase start element")
        let prefix = spec?.prefix ?? ""
        let localName = spec?.localname ?? ""
        let element = getElement(fullElement: elementName)
        // We double check the current prefix/localname to prevent for example amin::mkdir being executed
        // instead of my_corp::mkdir
        if(element.prefix == prefix && element.localName == localName) {
            if let name = attributeDict["name"] {
                command = name
            } else {
                command = element.localName
            }
        }
        self.element = elementName
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }


    func commandMessage() {
        // TODO Dumps success message  / OUT / Error to Log.

    }

    func launchCommand() {

        // TODO Support debug.
        let pipe = Pipe()
        let task = Process()
        task.environment = environmentVariables
        task.launchPath = command
        task.arguments = parameters
        task.standardError = pipe
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        print("COMMAND: \(command) OUTPUT: \(output)")
        if (task.terminationStatus == 0) {
            // TODO Handle error.
        }
    }
}
