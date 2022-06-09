import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminMachineFilterDispatcher: XmlSaxBase {
    required init() {
        super.init()
    }

    override func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        print("Prefix: \(prefix) Namespace: \(namespaceURI)")
    }

    override func parserDidStartDocument(_ parser: XMLParser) {
        if let spec = spec {
            // In Perl Land there was magic abound leveraging 'chain' we have to do things the hard.
            spec.filters?.forEach { (filter) in
                filter.parserDidStartDocument(parser)
            }
            spec.writer?.parserDidStartDocument(parser)
        }
    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        if let spec = spec {
            spec.writer?.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
            if(spec.aminError) {
                delegate = AminMachineHandlerEmpty()
            } else {
                // In Perl Land there was magic abound leveraging 'chain' we have to do things the hard.
                spec.filters?.forEach { (filter) in
                    filter.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
                }
            }

        }
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (spec!.aminError) {
            delegate = AminMachineHandlerEmpty()
        } else {
            // In Perl Land there was magic abound leveraging 'chain' we have to do things the hard.
            spec?.filters?.forEach { (filter) in
                filter.parser(parser, foundCharacters: string)
            }
        }
        spec?.writer?.parser(parser, foundCharacters: string)
        super.parser(_: parser, foundCharacters: string)
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (spec!.aminError) {
            delegate = AminMachineHandlerEmpty()
        } else {
            // In Perl Land there was magic abound leveraging 'chain' we have to do things the hard.
            spec?.filters?.forEach { (filter) in
                filter.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
            }
        }
        spec?.writer?.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        super.parser(_: parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }

    override func parserDidEndDocument(_ parser: XMLParser) {
        if let spec = spec {
            // In Perl Land there was magic abound leveraging 'chain' we have to do things the hard.
            spec.filters?.forEach { (filter) in
                filter.parserDidEndDocument(parser)
            }
            spec.writer?.parserDidEndDocument(parser)
        }
    }
}
