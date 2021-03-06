import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminMachineDispatcher: XmlSaxBase {

    public required init() {

    }

    init(machineSpec: Spec!) {
        super.init()
        spec = machineSpec
    }
    
    private var currentFilter: XmlSaxBase? = nil

    // Sorts the filters into the correct order for dispatching.
    // This also sets up the chains for each 'middle' filter.
    private func setFilterHandlers() {
        print("setFilterHandlers")
    }

    public override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        spec!.writer.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        currentFilter?.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        if(elementName == "amin:command") {
            currentFilter = nil
        }
    }

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        spec!.writer.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)

        // TODO Check spec for error.
        
        // TODO This is a nasty hack to get things going somewhere near expected.
        if(elementName == "amin:command") {
            let middleFilters = spec!.filters["middle"]!
            let filterName = attributeDict["name"]!
            currentFilter = middleFilters[filterName]!
        }
        currentFilter?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        spec!.writer.parser(parser, foundCharacters: string)
        currentFilter?.parser(parser, foundCharacters: string)
    }
}
