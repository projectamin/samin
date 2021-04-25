import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminCommandMkdir: AminCommandBase {

    private var log : AminLog = AminLogStandard.shared

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        commandName = "mkdir"
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(commandName == command) {
            if(element == "amin:param") {
                print(element)
                if let range = string.range(of: paramRegex, options: .regularExpression) {
                    print(string[range])
                } else {
                    print("No params")
                }
            }
            charactersShell(data: string)
            if(element == "amin:flag") {
                print("Flag: \(element)")
            }
        } else {
            super.parser(_: parser, foundCharacters: string)
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == localName && command == commandName) {
            launchCommand()
        }
        super.parser(_: parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }
}

