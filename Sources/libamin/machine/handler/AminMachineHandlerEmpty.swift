import Foundation

class AminMachineHandlerEmpty: AminCommandBase {

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        spec?.prefix = "amin"
        spec?.localname = "command"
        commandName = "empty"
        command = "empty"
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        super.parser(_: parser, foundCharacters: string)
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let element = getElement(fullElement: elementName)
        if(element.localName == spec?.localname && command == commandName) {
            let text = "This element was not processed"
            spec?.log?.writeMessage(message: text, attributes: [
                "type": "not processed"
            ])
        }
        super.parser(_: parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }
}
