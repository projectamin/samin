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
                let params = paramRegex?.matches(in: string, range: NSRange(location: 0, length: string.count))
                params?.forEach { result in
                    print(result)
                }
            }
            charactersShell(data: string)
            if(element == "amin:flag") {
                print(element)
            }
        } else {
            super.parser(_: parser, foundCharacters: string)
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == localName && command == commandName) {
            launchCommand()
        }
    }
}

