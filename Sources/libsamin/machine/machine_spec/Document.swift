import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class Document: XmlSaxBase {

    var filters = Dictionary<String, Filter>()
    var currentFilter: Filter? = nil
    var currentFilterClass:String? = nil
    var currentElement: String? = nil
    var machineName: String? = nil
    var generatorClass: String? = nil
    var handlerClass: String? = nil
    var logClass: String? = nil

    // Strips out :: in machine spec to map to swift class names.
    func processFilterName(name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "::", with: "", options: NSString.CompareOptions.literal, range: nil)
    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        super.parserDidStartDocument(parser)
        switch(elementName) {
        case "filter":
            currentFilter = Filter()
            currentFilterClass = processFilterName(name: attributeDict["name"]!)
        case "generator":
            generatorClass = processFilterName(name: attributeDict["name"]!)
        case "handler":
            handlerClass = processFilterName(name: attributeDict["name"]!)
        case "writer":
            logClass = processFilterName(name: attributeDict["name"]!)
        default:
            currentElement = elementName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch (currentElement) {
        case "element":
            currentFilter?.element += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "namespace":
            currentFilter?.namespace += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "name":
            currentFilter?.name += processFilterName(name: string)
        case "download":
            currentFilter?.download += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "position":
            currentFilter?.position += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "version":
            currentFilter?.version += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "module":
            currentFilter?.module += string.trimmingCharacters(in: .whitespacesAndNewlines)
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
