import Foundation
import FoundationXML

public class Samin {

    // TODO Temporary to get going
    let outputstream = OutputStream.toMemory()

    init() {
        print("Amin - brought to you by the magic of dahuts everywhere.")
    }

    func parse(profileUri: URL) {
        // TODO Generate input stream from URL/URI and call inputstream overload.
    }

    func parse(profileUri: URL, machineSpecification: URL) {

    }

    func parse(profileStream: InputStream) -> OutputStream {

        let machineSpec = MachineSpec()

        // TODO manage xinclude.
        let xinclude = XInclude()

        xinclude.delegate = machineSpec


        // TODO revisit machine spec - we should trigger this just using
        // TODO passed in URI or default i.e. don't have path magic in
        // TODO spec filter pull into setup aka here / related thing
        // TODO and leave spec filter doing parsing logic only.
        // TODO haven't got there yet but suspect profile stream will
        // TODO need resetting as it will have been read to end.
        // TODO non optimal for stream processing. We want bytes off pipe
        // TODO being stuff straight into parser below not triggering spec read.
        var specXmlTrigger = "<trigger xmlns:amin='http://projectamin.org/ns/'></trigger>"
        var data = specXmlTrigger.data(using: .utf8)
        var inputStream = InputStream(data: data!)
        var machineSpecParser = XMLParser(stream: inputStream)
        machineSpecParser.delegate = xinclude
        machineSpecParser.parse()

        let loadedSpec = machineSpec.machineSpec
        loadedSpec.buffer = outputstream

        // TODO Once we handle custom machines/handler/generator allow such for the moment we just default
        // TODO to AminMachineDispatcher.

        let machine = AminMachineDispatcher(machineSpec: loadedSpec)

        var parser = XMLParser(stream: profileStream)
        parser.delegate = machine
        parser.parse()


        // TODO place holder to allow things to compile till the
        // TODO output buffer is returned.
        // TODO Amin perl implementation returns the spec Buffer_End
        let s = "<xml></xml>"
        let encodedDataArray = [UInt8](s.utf8)
        outputstream.write(encodedDataArray, maxLength: encodedDataArray.count)
        return outputstream
    }

    func parse(profileStream: InputStream, machineSpecification: InputStream) {

    }

}


