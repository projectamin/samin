//
// Created by swishy on 29/08/20.
//

import Foundation
import FoundationXML

class MachineSpec: XmlSaxBase {

    var machineSpec = Spec()

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

            // Here we attempt to load and sort filters into correct position.
            do {
                try document.filters.forEach{
                    key, value in
                    print(key)

                    // TODO Work out how to handle forced casting error when fails.
                    // TODO So we can catch graceful and set machine error state eventually.
                    let createdClass = NSClassFromString("samin.\(key)") as! XmlSaxBase.Type
                    let instance = createdClass.init()


                    var foo = AminCommandEcho()
                    var classType = type(of: key)
                    // var instance = classType.init() as? XmlSaxBase
                    // var instance = Bundle.main.classNamed("\(key)") as? XmlSaxBase
                    if(instance == nil) {
                        throw MachineSpecError.unableToLoadFilter(filter: key)
                    }
                    switch(value.position) {
                    case "begin":
                        self.machineSpec.filters["begin"]![key] = instance
                    case "permanent":
                        self.machineSpec.filters["permanent"]![key] = instance
                    case "middle":
                        self.machineSpec.filters["middle"]![key] = instance
                    case "end":
                        self.machineSpec.filters["end"]![key] = instance
                    default:
                        throw MachineSpecError.invalidPosition
                    }
                    print(instance)
                }
            } catch {
                print("Error loading filters: \(error)")
            }


            print("Begin Filters Loaded: \(machineSpec.filters["begin"]!.count)")
            print("Permanent Filters Loaded: \(machineSpec.filters["permanent"]!.count)")
            print("Middle Filters Loaded: \(machineSpec.filters["middle"]!.count)")
            print("End Filters Loaded: \(machineSpec.filters["end"]!.count)")


        }

    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

}