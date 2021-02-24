//
// Created by swishy on 2/16/21.
//
import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminMachineHandlerWriter: XmlSaxBase {

    public required init() {

    }

    init(machineSpec: Spec!) {
        super.init()
        spec = machineSpec
    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        var startElement = "<"
        startElement += elementName

        // TODO deal with namespace. Refactor into common write functions.
        if ((attributeDict.count) != 0) {
            attributeDict.forEach { attribute in
                startElement += " \(attribute.key)=\"\(attribute.value)\""
            }
        }

        startElement += ">"

        let xmlByteArray = [UInt8](startElement.utf8)

        writeToOutputStream(data: xmlByteArray, length: xmlByteArray.count)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        let charactersArray = [UInt8](string.utf8)
        writeToOutputStream(data: charactersArray, length: charactersArray.count)
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let endElement = "</\(elementName)>"
        let xmlByteArray = [UInt8](endElement.utf8)
        writeToOutputStream(data: xmlByteArray, length: xmlByteArray.count)
    }

    // Marshall back to the main thread for updating the output stream
    private func writeToOutputStream(data: [UInt8], length: Int) {
        _ = spec!.buffer!.write(data, maxLength:length)
    }
}
