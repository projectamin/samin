//
// Created by swishy on 2/16/21.
//

import XCTest

@testable import libamin

class AminWriterTests: XCTestCase, StreamDelegate {
    func testWriter() {
        let amin = Amin()
        let spec =
            "<machine xmlns:amin=\"http://projectamin.org/ns/\"><name>Amin::Machine::Dispatcher</name><filter name=\"Amin::Command::Echo\"><namespace>amin</namespace><element>command</element><name>echo</name><position>middle</position><download>http://projectamin.org/filters/amin/command/echo.xml</download><version>1.0</version></filter></machine>"
        let profile =
            "<amin:profile xmlns:amin=\"http://projectamin.org/ns/\"><amin:command name=\"echo\">WeCanHasCharacters</amin:command></amin:profile>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let outputStream = OutputStream(toMemory: ())
        outputStream.delegate = self
        print("Opening Stream")
        outputStream.open()

        amin.parse(
            profileStream: inputStream, outputStream: outputStream,
            machineSpecification: InputStream(data: spec.data(using: .utf8)!))

        // Wait for amin to close the stream post parsing.
        let outputData =
            outputStream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        let outputBytes = [UInt8](outputData)
        let outputXml = String(decoding: outputBytes, as: UTF8.self)
        assert(profile == outputXml)
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("has bytes available")
        //readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            print("new message received")
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }

    static var allTests = [
        ("testWriter", testWriter)
    ]
}
