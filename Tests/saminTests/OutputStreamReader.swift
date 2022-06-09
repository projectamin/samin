//
// Created by Dale Anderson on 20/12/21.
//

import Foundation

class OutputStreamReader: NSObject, StreamDelegate {

    let maxReadLength = 4096

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

    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = stream.read(buffer, maxLength: maxReadLength)

            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }

            print(processedMessageString(buffer: buffer, length: numberOfBytesRead) as Any)
        }
    }

    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> String? {
        guard
                let string = String(
                        bytesNoCopy: buffer,
                        length: length,
                        encoding: .utf8,
                        freeWhenDone: true)
                else {
            return nil
        }

        return string
    }
}
