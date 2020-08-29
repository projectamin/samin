import Foundation
import FoundationXML

class Document: XmlSaxBase {

    var filters = Array<Filter>()
    var currentFilter = Filter()
    var currentElement: String? = nil

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

        if(elementName == "filter") {
            currentFilter = Filter()
        } else {
            currentElement = elementName
        }
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch (currentElement) {
        case "element":
            currentFilter.element = string
        case "namespace":
            currentFilter.namespace = string
        case "name":
            currentFilter.name = string
        case "position":
            currentFilter.download = string
        case "version":
            currentFilter.version = string
        case "module":
            currentFilter.module = string
        default:
            print("")
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "filter") {
            filters.append(currentFilter)
        }
    }

    override func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing machine_spec")
        print("Filters: \(filters.count)")
    }

}