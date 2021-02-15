import XCTest
@testable import samin

final class saminTests: XCTestCase, StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("STREAM EVENT")
        print(eventCode)
    }

    func testCrankSamin() {
        let amin = Samin()
        let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let output = amin.parse(profileStream: inputStream)
        output.delegate = self
        output.open()
        assert(output.streamStatus == .open)
    }

    func testEcho() {
        let amin = Samin()
        let profile = ""
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let output = amin.parse(profileStream: inputStream)

        output.delegate = self
        output.open()
        print(output.streamStatus)


    }

    func testArch() {
        var amin = Samin()
        var inputStream = InputStream(fileAtPath: "xml/arch.xml")!
        amin.parse(profileStream: inputStream)
    }

    static var allTests = [
        ("testCrankSamin", testCrankSamin),
        ("testEcho", testEcho),
        ("testArch", testArch)
    ]
}
