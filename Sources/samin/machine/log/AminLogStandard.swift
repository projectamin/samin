//
// Created by swishy on 2/15/21.
//

import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminLogStandard: AminLog {

    private var spec: Spec?
    private var parser: XMLParser?

    func writeMessage(message: String, attributes: [String: String]) {
        print("AminLogStandard - writeMessage")
        driverStartElement(element: "amin:message", attributes: attributes)
        driverChars(characters: message)
        driverEndElement(element: "amin:message")
    }

    func error(message: String) {
        let attributes = ["type": "error"]
        writeMessage(message: message, attributes: attributes)
    }

    func warning(message: String) {
        let attributes = ["type": "warn"]
        writeMessage(message: message, attributes: attributes)
    }

    func success(message: String) {
        let attributes = ["type": "success"]
        writeMessage(message: message, attributes: attributes)
    }

    func aminIn(message: String) {
        let attributes = ["type": "IN"]
        writeMessage(message: message, attributes: attributes)
    }

    func aminOut(message: String) {
        let attributes = ["type": "OUT"]
        writeMessage(message: message, attributes: attributes)
    }

    func aminError(message: String) {
        let attributes = ["type": "ERR"]
        writeMessage(message: message, attributes: attributes)
    }


    func driverStartElement(element: String, attributes:[String: String]) {
        spec?.writer.parser(parser!, didStartElement: element, namespaceURI: nil, qualifiedName: nil, attributes: attributes)
    }

    func driverEndElement(element: String) {
        spec?.writer.parser(parser!, didEndElement: element, namespaceURI: nil, qualifiedName: nil)
    }

    func driverChars(characters: String) {
        spec?.writer.parser(parser!, foundCharacters: characters)
    }

}
