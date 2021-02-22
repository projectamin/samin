import Foundation
import FoundationXML

public class Samin {

    // TODO Temporary to get going is equal to the Buffer in perl.
    let outputstream = OutputStream.toMemory()
    var spec: Spec?

    init() {
        print("Amin - brought to you by the magic of dahuts everywhere.")
    }

    func parse(profileUri: URL) {
        // TODO Generate input stream from URL/URI and call inputstream overload.
    }

    func parse(profileUri: URL, machineSpecification: URL) {

    }

    func parse(profileStream: InputStream) -> OutputStream {

        // NOTE this varies from Perl where it needs to be triggered by profile processing.
        // here we load the spec up front until I decide Bryan was right and this is a bad idea.
        let machineSpecProcessor = MachineSpecProcessor()

        // TODO manage xinclude.
        let xinclude = XInclude()
        xinclude.delegate = machineSpecProcessor


        // TODO revisit machine spec - we should trigger this just using
        // TODO passed in URI or default i.e. don't have path magic in
        // TODO spec filter pull into setup aka here / related thing
        // TODO and leave spec filter doing parsing logic only.
        // TODO haven't got there yet but suspect profile stream will
        // TODO need resetting as it will have been read to end.
        // TODO non optimal for stream processing. We want bytes off pipe
        // TODO being stuff straight into parser below not triggering spec read.
        machineSpecProcessor.parseMachineSpec()

        spec = machineSpecProcessor.machineSpec
        print("loadedSpec \(spec!)")
        spec!.buffer = outputstream


        // TODO Once we handle custom machines/handler/generator allow such for the moment we just default
        // TODO to AminMachineDispatcher.

        let machine = AminMachineDispatcher(machineSpec: spec!)

        // This is the core machine parser.
        let profileParser = XMLParser(stream: profileStream)
        profileParser.delegate = machine

        // Make sure the output stream is open for writing.
        outputstream.open()

        // OK here we launch the parsing off into the sunset and return the stream immediately.
        let queue = DispatchQueue(label: "Amin Dispatch Queue")
        queue.async { [self] in
            let success = profileParser.parse()
            // Close stream back on main thread.
            DispatchQueue.main.sync {
                outputstream.close()
            }
            if(success) {
                print("Parsing succeeded")
            } else {
                print("Parsing failed.")
            }
        }
        return outputstream
    }

    func parse(profileStream: InputStream, machineSpecification: InputStream) {

    }

}


