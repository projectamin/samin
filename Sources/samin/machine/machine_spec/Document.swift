import Foundation
import FoundationXML

class Document: XmlSaxBase {

    var filters = Dictionary<String, Filter>()
    var currentFilter: Filter? = nil
    var currentFilterName:String? = nil
    var currentElement: String? = nil
    var machineName: String? = nil

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName == "filter") {
            currentFilter = Filter()
            currentFilterName = attributeDict["name"]
            print(currentFilterName!)
        } else {
            currentElement = elementName
        }
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch (currentElement) {
        case "element":
            currentFilter?.element = string
        case "namespace":
            currentFilter?.namespace = string
        case "name":
            currentFilter?.name = string
        case "position":
            currentFilter?.download = string
        case "version":
            currentFilter?.version = string
        case "module":
            currentFilter?.module = string
        default:
            return
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "filter") {
            filters[currentFilterName!] = currentFilter
        }
    }
}