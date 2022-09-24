import libsamin
import ArgumentParser
import Foundation

struct SaminCli: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Process profile via STDIN")
    var profile = false

    @Option(name: .shortAndLong, help: "A URI containing an amin profile to process.")
    var uri: String?

    mutating func run() throws {
        if(profile) {
            guard let inputStream = InputStream(fileAtPath: "/dev/stdin") else {
                throw AminError.streamError(error: "Unable to access stdin")
            }
            inputStream.open()
            let amin = Samin()
            guard let outputStream = OutputStream(toFileAtPath: "/dev/stdout", append: false) else {
                throw AminError.streamError(error: "Unable to access stdout")
            }
            outputStream.schedule(in: .main, forMode: .default)
            outputStream.open()
            amin.parse(profileStream: inputStream, outputStream: outputStream)
        }
        if(uri != nil) {
            let amin = Samin()
            let url = URL(string: uri!)
            print("Processing URI: \(uri!)")
            guard let outputStream = OutputStream(toFileAtPath: "/dev/stdout", append: false) else {
                throw AminError.streamError(error: "Unable to access stdout")
            }
            outputStream.schedule(in: .main, forMode: .default)
            outputStream.open()
            try amin.parse(profileUri: url!, outputStream: outputStream)
            outputStream.close()
        }
    }
}

SaminCli.main()


