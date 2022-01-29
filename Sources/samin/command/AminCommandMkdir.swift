import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminCommandMkdir: AminCommandBase {

    // Used to replicate Perl tracking current element via spec..
    private let prefix = "amin"
    private let localname = "command"

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("mkdir filter start element")
        let element = getElement(fullElement: elementName)
        spec?.prefix = element.prefix
        spec?.localname = element.localName
        commandName = "mkdir"
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    public override func parser(_ parser: XMLParser, foundCharacters string: String) {

        if(string != nil && command == commandName) {


        } else {
            super.parser(parser, foundCharacters: string)
        }
    }
}
