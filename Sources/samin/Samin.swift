import Foundation
import FoundationXML

public class Samin {
    func parse(profileUri: URL) {
        // TODO Generate input stream from URL/URI and call inputstream overload.
    }

    func parse(profileUri: URL, machineSpecification: URL) {

    }

    func parse(profileStream: InputStream) -> OutputStream {

        var machineSpec = MachineSpec()

        // TODO manage xinclude.
        var xinclude = XInclude()

        xinclude.delegate = machineSpec

        var parser = XMLParser(stream: profileStream)
        parser.delegate = xinclude
        parser.parse()

        var loadedSpec = machineSpec.machineSpec

        // TODO place holder to allow things to compile till the
        // TODO output buffer is returned.
        // TODO Amin perl implementation returns the spec Buffer_End
        let s = "<xml></xml>"
        let encodedDataArray = [UInt8](s.utf8)
        let outputstream = OutputStream.toMemory()
        outputstream.write(encodedDataArray, maxLength: encodedDataArray.count)
        return outputstream
    }

    func parse(profileStream: InputStream, machineSpecification: InputStream) {

    }

}


