//
// Created by swishy on 2/16/21.
//

import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif
@testable import libamin

class AminWriterTest: XmlSaxBase {

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        print("Writer Test!")
    }
}
