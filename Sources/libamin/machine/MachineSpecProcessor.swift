import Foundation
import OrderedCollections

#if canImport(FoundationXML)
    import FoundationXML
#endif

class MachineSpecProcessor: XmlSaxBase {

    private var filters: OrderedDictionary<String, [XmlSaxBase]> = [
        "begin": [], "middle": [], "end": [],
    ]

    // TODO make this pluggable so we can pull from NSBundle on iOS
    func getMachineSpecPath() -> String {
        let fileManager = FileManager.default
        if let home = ProcessInfo.processInfo.environment["HOME"] {
            if fileManager.fileExists(atPath: home + "/.amin/machine_spec.xml") {
                return home + "/.amin/machine_spec.xml"
            }
        }
        if let envSpec = ProcessInfo.processInfo.environment["AMIN_MACHINE_SPEC"] {
            if fileManager.fileExists(atPath: envSpec) {
                return envSpec
            }
        }
        return "/etc/machine_spec.xml"
    }

    private func loadFromUri(uri: URL?) throws -> Document {
        let machineSpecUrl = uri != nil ? uri : URL(string: getMachineSpecPath())
        let document = Document()
        let include = XInclude()
        include.delegate = document

        let fileHandle = FileHandle(forReadingAtPath: machineSpecUrl!.absoluteString)
        if fileHandle != nil {
            let data = fileHandle?.readDataToEndOfFile()
            fileHandle?.closeFile()
            let parser = XMLParser(data: data!)
            parser.delegate = include
            parser.parse()
            return document
        } else {
            throw MachineSpecError.unableToAccessSpec(path: machineSpecUrl!.absoluteString)
        }
    }

    private func loadFromStream(machineSpecification: InputStream) -> Document {
        let document = Document()
        let include = XInclude()
        include.delegate = document
        let parser = XMLParser(stream: machineSpecification)
        parser.delegate = include
        parser.parse()
        return document
    }

    // TODO Allow passing machine spec url.
    public func parseMachineSpec(machineSpecification: InputStream?) {
        spec = Spec()

        do {

            let document =
                try machineSpecification != nil
                ? self.loadFromStream(machineSpecification: machineSpecification!)
                : self.loadFromUri(uri: nil)

            try document.filters.forEach {
                key, value in

                // TODO Work out how to handle forced casting error when fails.
                // TODO So we can catch graceful and set machine error state eventually.
                guard let createdClass = NSClassFromString("libamin.\(key)") else {
                    throw MachineSpecError.unableToLoadFilter(filter: key)
                }
                let typedInstance = createdClass as! XmlSaxBase.Type
                let instance = typedInstance.init()

                if instance == nil {
                    throw MachineSpecError.unableToLoadFilter(filter: key)
                }
                switch value.position {
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
            }

            if let logger = document.logClass {
                // TODO sort out loading of Log with AminLog being a protocol and being uable to have a
                // TODO default constructor declared.
                // let createdClass = NSClassFromString("libamin.\(logger)")
                // let typedInstance = createdClass as! AminLog.Type
                // let instance = typedInstance.init()
                // spec?.log = instance
                spec?.log = AminLogStandard()
                spec?.log?.spec = spec
            } else {
                // Default to AminLogStandard
                spec?.log = AminLogStandard()
                spec?.log?.spec = spec
            }

            // TODO Bandaid to test it works.
            spec?.writer = AminMachineHandlerWriter(machineSpec: spec)

            spec?.filters = filters.values.reduce([]) { (result, item) in
                result + item
            }
        } catch {
            print("Error loading filters: \(error)")
        }
    }

    override func parser(
        _ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?, attributes attributeDict: [String: String]
    ) {
        super.parser(
            parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName,
            attributes: attributeDict)
    }

}
