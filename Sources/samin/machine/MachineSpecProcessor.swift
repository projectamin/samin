import Foundation
import OrderedCollections
#if canImport(FoundationXML)
import FoundationXML
#endif

class MachineSpecProcessor: XmlSaxBase {

    private var filters: OrderedDictionary<String, [XmlSaxBase]> = ["begin": [], "middle": [], "end": []]

    // TODO make this pluggable so we can pull from NSBundle on iOS
    func getMachineSpecPath() -> String {
        let fileManager = FileManager.default
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
        spec = Spec()
        let machineSpecUrl = URL(string: getMachineSpecPath())!
        print(machineSpecUrl)

        let document = Document()
        let include = XInclude()
        include.delegate = document

        let fileHandle = FileHandle(forReadingAtPath: machineSpecUrl.absoluteString)

        if fileHandle != nil {
            let data = fileHandle?.readDataToEndOfFile()
            fileHandle?.closeFile()
            let parser = XMLParser(data: data!)
            parser.delegate = include
            print("Parsing machine spec.")
            parser.parse()

            // Here we attempt to load and sort filters into correct position.
            do {
                try document.filters.forEach{
                    key, value in

                    // TODO Work out how to handle forced casting error when fails.
                    // TODO So we can catch graceful and set machine error state eventually.
                    guard let createdClass = NSClassFromString("samin.\(key)") else {
                        print("Unable to create instance of filter \(key)")
                        throw MachineSpecError.unableToLoadFilter(filter: key)
                    }
                    let typedInstance = createdClass as! XmlSaxBase.Type
                    let instance = typedInstance.init()

                    if(instance == nil) {
                        throw MachineSpecError.unableToLoadFilter(filter: key)
                    }
                    switch(value.position) {
                    case "begin":
                        filters["begin"]!.append(instance)
                    case "middle":
                        filters["middle"]!.append(instance)
                    case "end":
                        filters["end"]!.append(instance)
                    case "permanent":
                        throw MachineSpecError.unsupportedPosition
                    default:
                        throw MachineSpecError.invalidPosition
                    }
                    print(instance)
                }
            } catch {
                print("Error loading filters: \(error)")
            }

            if let logger = document.logClass {
                // TODO sort out loading of Log with AminLog being a protocol and being uable to have a
                // TODO default constructor declared.
                // let createdClass = NSClassFromString("samin.\(logger)")
                // let typedInstance = createdClass as! AminLog.Type
                // let instance = typedInstance.init()
                // spec?.log = instance
                print("Custom Log Implementation declared in spec.")
                spec?.log = AminLogStandard()
            } else {
                // Default to AminLogStandard
                spec?.log = AminLogStandard()
            }


            print("Begin Filters Loaded: \(filters["begin"]?.count)")
            print("Permanent Filters Loaded: \(filters["permanent"]?.count)")
            print("Middle Filters Loaded: \(filters["middle"]?.count)")
            print("End Filters Loaded: \(filters["end"]?.count)")

            spec?.filters = filters.values.reduce([]) {(result, item) in
                result + item
            }
        }

    }

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }

}
