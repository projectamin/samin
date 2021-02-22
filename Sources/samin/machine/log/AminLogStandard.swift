//
// Created by swishy on 2/15/21.
//

import Foundation
import FoundationXML

class AminLogStandard: XmlSaxBase {

    func driverStartElement(element: String, attributes:[String: String]) {
        spec?.writer.parser(<#T##parser: XMLParser##FoundationXML.XMLParser#>, didStartElement: element, namespaceURI: nil, qualifiedName: nil, attributes: attributes)
    }

    func driverEndElement(element: String) {
        spec?.writer.parser(<#T##parser: XMLParser##FoundationXML.XMLParser#>, didEndElement: element, namespaceURI: nil, qualifiedName: nil)
    }

    func driver

}
