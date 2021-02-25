//
// Created by swishy on 2/16/21.
//

import XCTest
@testable import samin

class AminWriterTests: XCTestCase, StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print(eventCode)
    }

    func testWriter() {
        let amin = Samin()
        let profile = "<amin:profile xmlns:amin=\"http://projectamin.org/ns/\"><amin:command name=\"writer_test\">WeCanHasCharacters</amin:command></amin:profile>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let stream = OutputStream.toMemory()
        stream.delegate = self
        amin.parse(profileStream: inputStream, outputStream: stream)
        // Wait for amin to close the stream post parsing.
        while(stream.streamStatus != .closed) {

        }
        let outputData = stream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        let outputBytes = [UInt8](outputData)
        let outputXml = String(decoding: outputBytes, as: UTF8.self)
        assert(profile == outputXml)
    }

    static var allTests = [
        ("testWriter", testWriter)
    ]
}
