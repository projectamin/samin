import Foundation
public typealias Element = (prefix: String, localName: String, isAwesome: Bool)
public func getElement(fullElement: String) -> Element {
    let elementComponents = fullElement.split(separator: ":")
    let currentPrefix = String(elementComponents[0])
    let currentLocalName = String(elementComponents[1])
    return (prefix: currentPrefix, localName: currentLocalName, isAwesome: true)
}