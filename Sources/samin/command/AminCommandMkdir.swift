import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class AminCommandMkdir: AminCommandBase {

    // Used to replicate Perl tracking current element via spec..
    private let prefix = "amin"
    private let localname = "command"

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("mkdir filter start element")
        let element = getElement(fullElement: elementName)
        spec?.prefix = element.prefix
        spec?.localname = element.localName
        commandName = "mkdir"
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

    public override func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(command == commandName) {
            let localname = getElement(fullElement: element!).localName
            if(localname == "param") {
                let pattern = #"m/([\*\+\.\w=\/-]+|'[^']+')\s*/g"#
                do {
                    let regex = try NSRegularExpression(pattern: pattern, options: [])
                    let range = NSRange(description.startIndex..<description.endIndex,
                            in: description)
                    regex.enumerateMatches(in: description,
                            options: [],
                            range: range) { (match, _, stop) in
                        guard let match = match else { return }

                        print(match)
                    }
                } catch {
                    print("Error parsing params.")
                    spec?.log?.aminError(message: "Failed to parse params.")
                }
            }


        } else {
            super.parser(parser, foundCharacters: string)
        }
    }
}
