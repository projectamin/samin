import Foundation
import samin

class SaminCli: NSObject, StreamDelegate {
    func stream(aStream: Stream, handle eventCode: Stream.Event) {
        print("Event!")
        print(eventCode)
    }

    func main() {
        print("SAmin cause well.. 42")


        let amin = Samin()
        let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        let data = profile.data(using: .utf8)

        // Testing delegate

        let testStream = OutputStream.toMemory()
        testStream.delegate = self
        testStream.open()
        let xmlByteArray = [UInt8](profile.utf8)
        testStream.write(xmlByteArray, maxLength: xmlByteArray.count)
        testStream.close()

        // Testing delegate

        let inputStream = InputStream(data: data!)
        let outputstream = OutputStream.toMemory()
        inputStream.schedule(in: RunLoop.main, forMode: RunLoop.Mode.default)
        outputstream.schedule(in: RunLoop.main, forMode: RunLoop.Mode.default)
        outputstream.delegate = self
        inputStream.delegate = self
        amin.parse(profileStream: inputStream, outputStream: outputstream)

        let input = readLine()

        let outputData = outputstream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        let outputBytes = [UInt8](outputData)
        let outputXml = String(decoding: outputBytes, as: UTF8.self)
        print(outputXml)
        print("Profile processed")
    }
}

let app = SaminCli()
app.main()
