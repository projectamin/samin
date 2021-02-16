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
        print(spec)
        spec = machineSpec
    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        print("Writer!")
        print(spec)
        var startElement = "<"
        startElement += elementName + " "

        // TODO deal with namespace. Refactor into common write functions.
        if ((attributeDict.count) != 0) {
            attributeDict.forEach { attribute in
                startElement += attribute.key + ":" + attribute.value + " "
            }
        }

        startElement += ">"

        print(startElement)

        let xmlByteArray = [UInt8](startElement.utf8)

        print(spec)

        let result = spec!.buffer?.write(xmlByteArray, maxLength: xmlByteArray.count)
        print(result!)
    }
}
