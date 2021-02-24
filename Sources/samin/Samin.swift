import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif


public class Samin {

    // TODO Temporary to get going is equal to the Buffer in perl.
    let outputstream = OutputStream.toMemory()
    static var spec: Spec?
    let log: AminLog = AminLogStandard.shared

    init() {
        print("Amin - brought to you by the magic of dahuts everywhere.")

        print("Initialising the Machine...")

        // Setup dependency graph.
        SaminDependencies.singletons.add(AminLog.self, using: self.log)

        // NOTE this varies from Perl where it needs to be triggered by profile processing.
        // here we load the spec up front until I decide Bryan was right and this is a bad idea.
        let machineSpecProcessor = MachineSpecProcessor()

        // TODO manage xinclude.
        let xinclude = XInclude()
        xinclude.delegate = machineSpecProcessor
        machineSpecProcessor.parseMachineSpec()

        Samin.spec = machineSpecProcessor.machineSpec
        print("Machine Spec Loaded!")
        // TODO Below is awful remove and do properly.
        Samin.spec!.buffer = outputstream
    }

    func parse(profileUri: URL) {
        // TODO Generate input stream from URL/URI and call inputstream overload.
    }

    func parse(profileUri: URL, machineSpecification: URL) {

    }

    func parse(profileStream: InputStream) -> OutputStream {

        // OK here we launch the parsing off into the sunset and return the stream immediately.
        let queue = DispatchQueue(label: "Amin Dispatch Queue")
        queue.async { [self] in
            // TODO Once we handle custom machines/handler/generator allow such for the moment we just default
            // TODO to AminMachineDispatcher.
            // Make sure the output stream is open for writing.
            outputstream.schedule(in: RunLoop.main, forMode: RunLoop.Mode.default)
            outputstream.open()

            let machine = AminMachineDispatcher(machineSpec: Samin.spec!)

            // This is the core machine parser - should be the same instance available anywhere
            // within this machine chain. We create up front as log needs it currently.
            // TODO Inject later?
            let profileParser = XMLParser(stream: profileStream)

            // Set the Amin machine as the default handler.
            profileParser.delegate = machine
            let success = profileParser.parse()
            if(success) {
                print("Parsing succeeded")
            } else {
                print("Parsing failed.")
                print(profileParser.parserError ?? "Unknown error")
            }
            // Close stream.
            outputstream.close()
        }
        return outputstream
    }

    func parse(profileStream: InputStream, machineSpecification: InputStream) {

    }

}


