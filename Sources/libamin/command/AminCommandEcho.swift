import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminCommandEcho: AminCommandBase {
    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

    }
}
