import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class MachineSpecProcessor: XmlSaxBase {

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

    // TODO Allow passing machine spec url.
    public func parseMachineSpec() {
        print("machine spec start doc")

        let machineSpecUrl = URL(string: getMachineSpecPath())!
        print(machineSpecUrl)

        let document = Document()
        let include = XInclude()
        include.delegate = document

        let fileHandle = FileHandle(forReadingAtPath: getMachineSpecPath())

        if fileHandle != nil {
            let data = fileHandle?.readDataToEndOfFile()
            fileHandle?.closeFile()
            let parser = XMLParser(data: data!)
            parser.delegate = include
            parser.parse()

            // Here we attempt to load and sort filters into correct position.
            do {
                try document.filters.forEach{
                    key, value in

                    // TODO Work out how to handle forced casting error when fails.
                    // TODO So we can catch graceful and set machine error state eventually.
                    print(key)
                    var createdClass: AnyClass? = NSClassFromString("samin.\(key)")
                    print(createdClass)
                    if(createdClass == nil) {
                        createdClass = NSClassFromString("saminTests.\(key)")
                    }
                    let typedInstance = createdClass as! XmlSaxBase.Type
                    let instance = typedInstance.init()

                    switch(value.position) {
                    case "begin":
                        machineSpec.filters["begin"]![value.name] = instance
                    case "permanent":
                        machineSpec.filters["permanent"]![value.name] = instance
                    case "middle":
                        machineSpec.filters["middle"]![value.name] = instance
                    case "end":
                        machineSpec.filters["end"]![value.name] = instance
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
