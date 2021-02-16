import Foundation
import FoundationXML

class AminMachineDispatcher: XmlSaxBase {

    public required init() {

    }

    init(machineSpec: Spec!) {
        super.init()
        print("Dispacther machine spec \(machineSpec)")
        spec = machineSpec
    }

    // Sorts the filters into the correct order for dispatching.
    // This also sets up the chains for each 'middle' filter.
    private func setFilterHandlers() {
        let middleFilters = spec!.filters["middle"]!

    }

    public override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        spec!.writer.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        spec!.writer.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)

        // TODO Check spec for error.

        // TODO This is bollocks - dispatcher needs to set the handler chain for each filter in the stack
        // i.e. permanents in order then finally the command/cond etc filter itself
        // so when the sax event occurs it gets fired to all permanent then the appropriate
        // 'command' filter, this effectively splits the SAX event hierarchy into a sax event
        // triggering a chain of events in a static sequence as opposed to a one to one mapping.
        // TODO make machine/dispatcher pluggable as per Perl implementation so they can be
        // TODO setup to do different things.
        let middleFilters = spec!.filters["middle"]!
        if(elementName == "amin:command") {
            print("Dispatcher loading command filter")
            let filterName = attributeDict["name"]!
            print(filterName)
            let filter: XmlSaxBase = middleFilters[filterName]!
            delegate = filter
            delegate?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        } else {
            print("Dispatcher delegating")
            delegate?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        }
        //let filter: XmlSaxBase? = middleFilters![elementName]!
        //delegate = filter
        //delegate?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }
}
