import Foundation
import FoundationXML
class AminCondArch: XmlSaxBase {
    public override func parser(_ parser:  XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("AminCondArch")
        print(attributeDict)
    }
}