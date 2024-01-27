//
// Created by swishy on 2/16/21.
//
import Foundation
import FoundationXML

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

        // TODO deal with namespace.
        if ((attributeDict.count) != 0) {
            attributeDict.forEach { attribute in
                startElement += " \(attribute.key)=\"\(attribute.value)\""
            }
        }

        startElement += ">"

        writeToOutputStream(data: startElement)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        writeToOutputStream(data: string)
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let endElement = "</\(elementName)>"
        writeToOutputStream(data: endElement)
    }

    // Marshall back to the main thread for updating the output stream
    private func writeToOutputStream(data: String) {
        do {
            try spec!.buffer!.write(data)
        } catch {
            spec?.log?.aminError(message: "Unable to write data to output stream")
        }
    }
}
