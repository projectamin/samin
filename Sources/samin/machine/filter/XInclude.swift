//
// Created by swishy on 29/08/20.
//

import FoundationXML

class XInclude: XmlSaxBase {

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        // TODO implement xinclude support.
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

}