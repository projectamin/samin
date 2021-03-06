import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif


public class Samin {

    static var spec: Spec?
    public var delegate: SaminDelegate?
    let log: AminLog = AminLogStandard.shared

    public init() {
        print("Amin - brought to you by the magic of dahuts everywhere.")
        print("Initialising the Machine...")

        // NOTE this varies from Perl where it needs to be triggered by profile processing.
        // here we load the spec up front until I decide Bryan was right and this is a bad idea.
        let machineSpecProcessor = MachineSpecProcessor()

        // TODO manage xinclude.
        let xinclude = XInclude()
        xinclude.delegate = machineSpecProcessor
        machineSpecProcessor.parseMachineSpec()

        Samin.spec = machineSpecProcessor.machineSpec
        print("Machine Spec Loaded!")

    }

    func parse(profileUri: URL, outputStream: OutputStream) {
        let stream = InputStream(url: profileUri)
        parse(profileStream: stream!, outputStream: outputStream)
    }

    func parse(profileUri: URL, machineSpecification: URL) {

    }

    public func parse(profileStream: InputStream, outputStream: OutputStream) {

        if(Samin.spec!.error != nil) {
            print("Machine Spec load has error")
            print(Samin.spec!.error)
            print("Stopping processing.")
            // Close stream.
            outputStream.close()
            delegate?.profileCompleted()
            return
        }

        // TODO Below is awful remove and do properly.
        Samin.spec!.buffer = outputStream

        // Make sure the output stream is open for writing.
        outputStream.open()

        // OK here we launch the parsing off into the sunset and return the stream immediately.
        let queue = DispatchQueue.global(qos: .background)
        queue.async { [self] in
            // TODO Once we handle custom machines/handler/generator allow such for the moment we just default
            // TODO to AminMachineDispatcher.
            

            let machine = AminMachineDispatcher(machineSpec: Samin.spec!)

            // This is the core machine parser - should be the same instance available anywhere
            // within this machine chain. We create up front as log needs it currently.
            let profileParser = XMLParser(stream: profileStream)

            // Set the Amin machine as the default handler.
            profileParser.delegate = machine
            let success = profileParser.parse()
            if(!success) {
                print("Parsing failed.")
                print(profileParser.parserError ?? "Unknown error")
            }

            // Make sure we have no pending writes.
            while(outputStream.streamStatus == .writing) {
                print("waiting for pending writes.")
            }
            // Close stream.
            outputStream.close()
            delegate?.profileCompleted()
        }
    }

    func parse(profileStream: InputStream, machineSpecification: InputStream, outputStream: OutputStream) {

    }

}


