import Foundation
import FoundationXML

open class XmlSaxBase: XMLParserDelegate {

    // Akin to a handler in XML::SAX::Base in Perl land
    // we will refer to such in Objc/Swift terms.
    weak var delegate: XmlSaxBase?

    // This is just a very simple bandaid implementation to replicate basic principal of
    // Perls XML::SAX::Base
    public func parserDidStartDocument(_ parser: XMLParser) {
        delegate?.parserDidStartDocument(parser)
    }
    public func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parserDidEndDocument(parser)
    }
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        delegate?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        delegate?.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        delegate?.parser(parser, foundCharacters: string)
    }
}
