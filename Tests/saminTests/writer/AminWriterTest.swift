//
// Created by swishy on 2/16/21.
//

import Foundation
import FoundationXML
@testable import samin

class AminWriterTest: XmlSaxBase {

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        print("Writer Test!")
    }
}
