import XCTest

@testable import libamin

final class saminTests: XCTestCase, StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("STREAM EVENT")
        print(eventCode)
    }

    func testStreamMachineSpecification() {
        let amin = Amin()
        let spec =
            "<machine xmlns:amin=\"http://projectamin.org/ns/\"><name>Amin::Machine::Dispatcher</name><filter name=\"Amin::Command::Mkdir\"><namespace>amin</namespace><element>command</element><name>mkdir</name><position>middle</position><download>http://projectamin.org/filters/amin/command/mkdir.xml</download><version>1.0</version></filter></machine>"
        let profile =
            "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'><amin:flag name='m'>0755</amin:flag><amin:param name=\"target\">/tmp/test_ashell</amin:param></amin:command>"
        let specStream = InputStream(data: spec.data(using: .utf8)!)
        let inputStream = InputStream(data: profile.data(using: .utf8)!)
        let outputStream = OutputStream(toMemory: ())
        outputStream.open()
        amin.parse(
            profileStream: inputStream, outputStream: outputStream, machineSpecification: specStream
        )

        //assert(outputStream.streamStatus == .open)
    }

    func testEcho() {
        let amin = Amin()
        let profile = ""
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let outputStream = OutputStream(toMemory: ())
        print(outputStream.streamStatus)
        let streamDelegate = OutputStreamReader()
        outputStream.delegate = streamDelegate
        // outputStream.schedule(in: .current, forMode: .common)

        amin.parse(profileStream: inputStream, outputStream: outputStream)
        //while(outputStream.streamStatus == Stream.Status.writing) {

        //}
        //print("Closing stream")
        //outputStream.close()
    }

    func testArch() {
        let amin = Amin()
        let inputStream = InputStream(fileAtPath: "xml/arch.xml")!
        let outputStream = OutputStream(toMemory: ())
        amin.parse(profileStream: inputStream, outputStream: outputStream)
    }

    static var allTests = [
        ("testCrankSamin", testStreamMachineSpecification)
        //("testEcho", testEcho),
        //("testArch", testArch),
    ]
}
