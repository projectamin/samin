import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

// This is reflective of Amin::Elt - just found the original naming confusing.
class AminCommandBase: XmlSaxBase {

    private var directory: String?
    private var target: String?
    private var flags = [String]()
    private var source = [String]()
    private var parameters = [String]()
    private var command: String?
    private var commandName: String?
    private var attributes: String?
    private var environmentVariables = [String]()
    private var element: String?

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("AminCommandBase start element")
        print(attributeDict)
    }


    func commandMessage() {
        // TODO Dumps success message  / OUT / Error to Log.
    }

    func launchCommand() {

        // TODO Support debug.

        let task = Process()
        // task.launchPath
        // task.arguments =
        // task.environment = // array of var / value
        // task.standardError = // Pipe object - valid on iOS also...
        // task.standardOutput = // Pipe object
    }
}
