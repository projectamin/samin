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
        // TODO Check spec for error.

        // TODO This is bollocks - dispatcher needs to set the handler chain for each filter in the stack
        // i.e. permanents in order then finally the command/cond etc filter itself
        // so when the sax event occurs it gets fired to all permanent then the appropriate
        // 'command' filter, this effectively splits the SAX event hierarchy into a sax event
        // triggering a chain of events in a static sequence as opposed to a one to one mapping.
        // TODO make machine/dispatcher pluggable as per Perl implementation so they can be
        // TODO setup to do different things.
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
