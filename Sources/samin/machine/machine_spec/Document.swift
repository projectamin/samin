import Foundation
import FoundationXML

class Document: XmlSaxBase {

    var filters = Dictionary<String, Filter>()
    var currentFilter: Filter? = nil
    var currentFilterClass:String? = nil
    var currentElement: String? = nil
    var machineName: String? = nil
    var generatorClass: String? = nil
    var handlerClass: String? = nil
    var logClass: String? = nil

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        super.parserDidStartDocument(parser)
        switch(elementName) {
        case "filter":
            currentFilter = Filter()
            currentFilterClass = attributeDict["name"]
            print(currentFilterClass!)
        case "generator":
            generatorClass = attributeDict["name"]
        case "handler":
            handlerClass = attributeDict["name"]
        case "log":
            logClass = attributeDict["name"]
        default:
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
        super.parserDidEndDocument(parser)
        if(elementName == "filter") {
            filters[currentFilterClass!] = currentFilter
        }
    }
}