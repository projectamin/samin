//
// Created by swishy on 29/08/20.
//

import Foundation
import FoundationXML

class MachineSpec: XmlSaxBase {

    var name: String? = nil
    var generator: String? = nil
    var handler: String? = nil
    var log: String? = nil
    var filters = Dictionary<String, Filter>()

    // TODO make this pluggable so we can pull from NSBundle on iOS
    func getMachineSpecPath() -> String {
        let fileManager = FileManager()
        if let home = ProcessInfo.processInfo.environment["HOME"] {
            if(fileManager.fileExists(atPath: home + "/.amin/machine_spec.xml")) {
                return home + "/.amin/machine_spec.xml"
            }
        }
        if let envSpec = ProcessInfo.processInfo.environment["AMIN_MACHINE_SPEC"] {
            if(fileManager.fileExists(atPath: envSpec)) {
                return envSpec
            }
        }
        return "/etc/machine_spec.xml"
    }

    override func parserDidStartDocument(_ parser: XMLParser) {
        super.parserDidStartDocument(parser)
        print("machine spec start doc")

        var machineSpecUrl = URL(string: getMachineSpecPath())!
        print(machineSpecUrl)

        var document = Document()
        var include = XInclude()
        include.delegate = document

        var fileHandle = FileHandle(forReadingAtPath: getMachineSpecPath())

        if fileHandle != nil {
            let data = fileHandle?.readDataToEndOfFile()
            fileHandle?.closeFile()
            var parser = XMLParser(data: data!)
            parser.delegate = include
            parser.parse()
        }

        self.filters = document.filters
        print("Filters: \(filters.count)")
    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        super.parserDidStartDocument(parser)
    }

}