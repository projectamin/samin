import Foundation
import samin
import NIO

class SaminCli: NSObject, StreamDelegate {

    // Write output to stdout as we go so we can pipe amin to other things.
    let stdout = FileHandle.standardOutput
    let maxReadLength = 4096

    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {

        switch(eventCode){
        case .hasBytesAvailable:
            let input = aStream as! InputStream
            readAvailableBytes(stream: input)
        case .hasSpaceAvailable:
            break
                //output
        default:
            break
        }
    }

    func main() {
        print("SAmin cause well.. 42")

        // Setup bound stream pair so when the outputstream written to within the Amin machine
        // recieves data we get it fed to us via the input stream.
        var xmlStream : InputStream?
        var outputStream : OutputStream?
        var readStream : Unmanaged<CFReadStream>?
        var writeStream : Unmanaged<CFWriteStream>?
        CFStreamCreateBoundPair(kCFAllocatorDefault, &readStream, &writeStream, 1024)
        xmlStream = readStream!.takeUnretainedValue()
        xmlStream!.delegate = self
        xmlStream!.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        xmlStream!.open()
        outputStream = writeStream!.takeUnretainedValue()
        var continueExecution = true
        DispatchQueue.main.async {
            let amin = Samin()
            let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
            let data = profile.data(using: .utf8)
            let inputStream = InputStream(data: data!)
            amin.parse(profileStream: inputStream, outputStream: outputStream!)
            print("Profile processed")
            continueExecution = false
        }

        while(continueExecution) {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
        }
    }

    private func readAvailableBytes(stream: InputStream) {
        //1
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)

        //2
        while stream.hasBytesAvailable {
            //3
            let numberOfBytesRead = stream.read(buffer, maxLength: maxReadLength)

            //4
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }

            processedMessageString(buffer: buffer, length: numberOfBytesRead)
        }
    }

    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) {
        stdout.write(Data(bytesNoCopy: buffer, count: length, deallocator: .none))
    }
}

let app = SaminCli()
app.main()
