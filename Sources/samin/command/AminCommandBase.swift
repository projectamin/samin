import Foundation
import FoundationXML

// This is reflective of Amin::Elt - just found the original naming confusing.
class AminCommandBase: XmlSaxBase {

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("AminCommandBase start element")
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
