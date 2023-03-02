import XCTest
@testable import libamin

final class saminTests: XCTestCase, StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("STREAM EVENT")
        print(eventCode)
    }

    func testCrankSamin() {
        let amin = Amin()
        let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let outputStream = OutputStream()
        amin.parse(profileStream: inputStream, outputStream: outputStream)

        assert(outputStream.streamStatus == .open)
    }

    func testEcho() {
        let amin = Amin()
        let profile = ""
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let outputStream = OutputStream()
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
        let outputStream = OutputStream()
        amin.parse(profileStream: inputStream, outputStream: outputStream)
    }

    static var allTests = [
        ("testCrankSamin", testCrankSamin),
        ("testEcho", testEcho),
        ("testArch", testArch),
    ]
}
