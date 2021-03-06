import Foundation
import samin

class SaminCliCore: NSObject, StreamDelegate, SaminDelegate {

    // Write output to stdout as we go so we can pipe amin to other things.
    let stdout = FileHandle.standardOutput
    let maxReadLength = 4096

    func profileCompleted() {
        print("Completed Exiting Amin")
        exit(EXIT_SUCCESS)
    }

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

    func processStream(inputStream: InputStream) {
        print("SAmin cause well.. 42")

        // Since we are a commandline app we need to manage our own runloop
        let aminRunloop = RunLoop.current

        // Setup bound stream pair so when the outputstream written to within the Amin machine
        // receives data we get it fed to us via the input stream.
        var xmlStream : InputStream?
        var outputStream : OutputStream?
        var readStream : Unmanaged<CFReadStream>?
        var writeStream : Unmanaged<CFWriteStream>?

        // As this is intended to be purely the amin CLI frontend we bind to memory
        // rather than a socket.
        CFStreamCreateBoundPair(kCFAllocatorDefault, &readStream, &writeStream, 1024)

        // This is an inputstream that gets data when the outputstream passed to the amin
        // machine is written too. It gets fed chunked data so we wire up a delegate to fed
        // data to stdout as it comes in.
        xmlStream = readStream!.takeUnretainedValue()
        xmlStream!.delegate = self
        xmlStream!.schedule(in: aminRunloop, forMode: RunLoop.Mode.default)
        xmlStream!.open()

        // This gets passed to the Amin core to allow it to be used within the machine.
        // Amin internally is stream based to allow us to bolt it behind http/tcp/websockets
        // and any other type of transport you feel the need to.
        outputStream = writeStream!.takeUnretainedValue()
        let amin = Samin()
        amin.delegate = self

        // We can kick things of here within the current process -
        // Amin internally dispatches XML parsing via GCD in the background.
        // The delegate method profileCompleted is called when the machine has
        // finished executing the profile and it handles exiting the current runloop.
        amin.parse(profileStream: inputStream, outputStream: outputStream!)

        // Lets kick things off!
        RunLoop.current.run()
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

