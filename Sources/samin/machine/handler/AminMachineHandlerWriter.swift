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

        // TODO deal with namespace. Refactor into common write functions.
        if ((attributeDict.count) != 0) {
            attributeDict.forEach { attribute in
                startElement += " \(attribute.key)=\"\(attribute.value)\""
            }
        }

        startElement += ">"

        print(startElement)

        let xmlByteArray = [UInt8](startElement.utf8)

        print(spec)

        let result = spec!.buffer?.write(xmlByteArray, maxLength: xmlByteArray.count)
        print(result!)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        let charactersArray = [UInt8](string.utf8)
        let result = spec!.buffer?.write(charactersArray, maxLength: charactersArray.count)
        print(result!)
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        var endElement = "</\(elementName)>"
        let xmlByteArray = [UInt8](endElement.utf8)
        let result = spec!.buffer?.write(xmlByteArray, maxLength: xmlByteArray.count)
        print(result!)
    }
}
