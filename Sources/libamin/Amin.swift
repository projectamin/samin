import Foundation

#if canImport(FoundationXML)
    import FoundationXML
#endif

public class Amin {

    var spec: Spec?

    public init() {
        print("Amin - brought to you by the magic of dahuts everywhere.")
    }

    public func parse(profileUri: URL, outputStream: OutputStream) throws {
        // TODO Generate input stream from URL/URI and call inputstream overload.
        if profileUri.isFileURL {
            guard
                let inputStream = InputStream(
                    fileAtPath: "/\(profileUri.host!)\(profileUri.relativePath)")
            else {
                throw AminError.streamError(
                    error: "Unable to access file: \(profileUri.absoluteString)")
            }
            parse(profileStream: inputStream, outputStream: outputStream)
        } else {
            guard let inputStream = InputStream(url: profileUri) else {
                throw AminError.streamError(
                    error: "Unable to access URL: \(profileUri.absoluteString)")
            }
            parse(profileStream: inputStream, outputStream: outputStream)
        }
    }

    func parse(profileUri: URL, machineSpecification: URL) {

    }

    public func parse(
        profileStream: InputStream, outputStream: OutputStream, machineSpecification: InputStream?
    ) {
        // TODO Not sure this is actually needed....
        //profileStream.schedule(in: .main, forMode: .common)
        //outputStream.schedule(in: .main, forMode: .common)
        profileStream.open()
        //outputStream.open()
        // print(profileStream.streamStatus)

        // NOTE this varies from Perl where it needs to be triggered by profile processing.
        // here we load the spec up front until I decide Bryan was right and this is a bad idea.
        let machineSpecProcessor = MachineSpecProcessor()

        // TODO manage xinclude.
        let xinclude = XInclude()
        xinclude.delegate = machineSpecProcessor

        print("Loading machine spec")
        // TODO revisit machine spec - we should trigger this just using
        // TODO passed in URI or default i.e. don't have path magic in
        // TODO spec filter pull into setup aka here / related thing
        // TODO and leave spec filter doing parsing logic only.
        // TODO haven't got there yet but suspect profile stream will
        // TODO need resetting as it will have been read to end.
        // TODO non optimal for stream processing. We want bytes off pipe
        // TODO being stuff straight into parser below not triggering spec read.
        machineSpecProcessor.parseMachineSpec(machineSpecification: machineSpecification)

        let spec = machineSpecProcessor.spec!
        spec.buffer = outputStream

        print("Creating Amin Machine")
        // TODO Once we handle custom machines/handler/generator allow such for the moment we just default
        // TODO to AminMachineDispatcher.
        let machine = AminMachineDispatcher(machineSpec: spec)

        // This is the core machine parser.
        let profileParser = XMLParser(stream: profileStream)
        profileParser.delegate = machine
        // TODO manage parser/spec references through the stack better.
        // TODO this is awful crap.
        spec.log?.parser = profileParser
        let result = profileParser.parse()
        if !result {
            spec.aminError = true
            spec.log?.aminError(message: "Parsing failed!")
        }
    }

    public func parse(profileStream: InputStream, outputStream: OutputStream) {
        self.parse(
            profileStream: profileStream, outputStream: outputStream, machineSpecification: nil)
    }

    func parse(profileStream: InputStream, machineSpecification: InputStream) {

    }

}
