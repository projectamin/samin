import XCTest
@testable import samin

final class saminTests: XCTestCase, StreamDelegate {

    func stream(_ stream: Stream, handle: Stream.Event) {
        print("STREAM EVENT")
        print(handle)
    }

    func testCrankSamin() {
        let amin = Samin()
        let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let output = amin.parse(profileStream: inputStream)

        while(output.streamStatus == .open) {

        }
        
        assert(output.streamStatus == .closed)
    }

    func testEcho() {
        let amin = Samin()
        let profile = ""
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let output = amin.parse(profileStream: inputStream)

        output.delegate = self
        print(output.streamStatus)

    }

    static var allTests = [
        ("testCrankSamin", testCrankSamin),
        ("testEcho", testEcho)
    ]
}
