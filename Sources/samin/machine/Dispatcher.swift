import Foundation
import FoundationXML

class AminMachineDispatcher: XmlSaxBase {

    private var filters: Dictionary<String, Dictionary<String, XmlSaxBase>>?

    public required init() {

    }

    init(machineSpec: Spec) {
        self.filters = machineSpec.filters
        super.init()
    }

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        // TODO Check element name / namespace and set handler as filter.
        // TODO Just checking middle only atm......we should only need middle here and begin / end should be start / end doc?
        let middleFilters = self.filters!["middle"]!
        if(elementName == "amin:command") {
            print("Dispatcher loading command filter")
            let filterName = attributeDict["name"]!
            print(filterName)
            let filter: XmlSaxBase = middleFilters[filterName]!
            delegate = filter
        } else {
            print("Dispatcher delegating")
            delegate?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        }
        //let filter: XmlSaxBase? = middleFilters![elementName]!
        //delegate = filter
        //delegate?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }
}
