import XCTest
@testable import samin

class TestStreamDelegate: NSObject, StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("STREAM EVENT")
        print(eventCode)
    }

}

final class saminTests: XCTestCase, StreamDelegate {



    func testCrankSamin() {
        let amin = Samin()
        let delegate = TestStreamDelegate()
        let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let stream = OutputStream.toMemory()
        stream.delegate = self
        amin.parse(profileStream: inputStream, outputStream: stream)

        while(stream.streamStatus == .open) {

        }

        
        assert(stream.streamStatus == .closed)
    }

    func testEcho() {
        let amin = Samin()
        let delegate = TestStreamDelegate()
        let profile = ""
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let stream = OutputStream.toMemory()
        stream.delegate = self
        amin.parse(profileStream: inputStream, outputStream: stream)

        stream.delegate = delegate
        print(stream.streamStatus)

    }

    static var allTests = [
        ("testCrankSamin", testCrankSamin),
        ("testEcho", testEcho)
    ]
}
