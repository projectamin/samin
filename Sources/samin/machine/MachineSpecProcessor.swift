import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class MachineSpecProcessor: XmlSaxBase {

    var machineSpec = Spec()
    private var defaultMachineSpec = "<machine xmlns:amin=\"http://projectamin.org/ns/\">\n        <!--    LICENSE:\n                Please see the LICENSE file included with this distribution \n                or see the following website http://projectamin.org.\n        -->\n\n\n        <!--what type of machine is this? -->\n        <name>Amin::Machine::Dispatcher</name>\n\n        <!-- default generator handler log and filter_param \n        <generator name=\"XML::SAX::PurePerl\"/>\n\n\n        <handler name=\"Amin::Machine::Handler::Writer\" output=\"int\" />\n\n\n        <log name=\"Amin::Machine::Log::Standard\" />\n        -->\n        <!--<filter_param>something_here somethings else</filter_param>-->\n\n\n        <!-- some special/extra amin filters that fit nowhere in particular-->\n        <filter name=\"Amin::Command::Mkdir\">\n                <namespace>amin</namespace>\n                <element>command</element>\n                <name>mkdir</name>\n                <position>middle</position>\n                <download>http://projectamin.org/filters/amin/command/mkdir.xml</download>\n                <version>1.0</version>\n        </filter>\n</machine>"

    // TODO make this pluggable so we can pull from NSBundle on iOS
    func getMachineSpecPath() throws -> String {
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

        if(fileManager.fileExists(atPath: "/etc/machine_spec.xml")) {
            return "/etc/machine_spec.xml"
        }

        // If we get here Bryan hasn't created a machine spec so we will set defaults
        // and return it.
        try setDefaultMachineSpec(fileManager: fileManager)

        return ProcessInfo.processInfo.environment["HOME"]! + "/.amin/machine_spec.xml"
    }

    func setDefaultMachineSpec(fileManager: FileManager) throws {
        if let home = ProcessInfo.processInfo.environment["HOME"] {
            let specData = defaultMachineSpec.data(using: .utf8)
            try fileManager.createDirectory(atPath: home + "/.amin/", withIntermediateDirectories: false)
            fileManager.createFile(atPath: home + "/.amin/machine_spec.xml", contents: specData)
        }
    }

    // TODO Allow passing machine spec url.
    public func parseMachineSpec() throws {

        let machineSpecUrl = try URL(string: getMachineSpecPath())!
        print("Using Machine Spec: ")
        print(machineSpecUrl)

        let document = Document()
        let include = XInclude()
        include.delegate = document

        let fileHandle = try FileHandle(forReadingAtPath: getMachineSpecPath())

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
                    var createdClass: AnyClass? = NSClassFromString("samin.\(key)")
                    if(createdClass == nil) {
                        // TODO bandaid to keep tests happy atm - fix.
                        createdClass = NSClassFromString("saminTests.\(key)")
                    }
                    if(createdClass == nil) {
                        parser.abortParsing()
                        machineSpec.error = MachineSpecError.unableToLoadFilter(filter: key)
                        throw machineSpec.error!
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
                        machineSpec.error = MachineSpecError.invalidPosition
                        throw machineSpec.error!
                    }
                }
            } catch {
                print("Error loading filters: \(error)")
                return
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
