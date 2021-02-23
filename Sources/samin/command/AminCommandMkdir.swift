import Foundation
import FoundationXML
import Inject

class AminCommandMkdir: AminCommandBase {

    private var log : AminLog = AminLogStandard()

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        log.success(message: "We Did Start Making A Directory!")
    }
}