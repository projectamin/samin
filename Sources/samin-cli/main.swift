import samin
import ArgumentParser
import Foundation

struct SaminCli: ParsableCommand {
    @Flag(help: "Process profile via STDIN")
    var profile = false

    @Option(name: .shortAndLong, help: "A URI containing an amin profile to process.")
    var uri: String?

    mutating func run() throws {
        print("Processing profile via stdin?")
        print(profile)
        if(profile) {
            guard let inputStream = InputStream(fileAtPath: "/dev/stdin") else {
                print("Unable to access stdin")
                return
            }
            inputStream.open()
            let amin = Samin()
            guard let outputStream = OutputStream(toFileAtPath: "/dev/stdout", append: true) else {
                print("Unable to access stdout")
                return
            }
            outputStream.schedule(in: .main, forMode: .default)
            outputStream.open()
            amin.parse(profileStream: inputStream, outputStream: outputStream)
        }
        if(uri != nil) {
            let amin = Samin()
            let url = URL(string: uri!)
            print("Processing URL")
            amin.parse(profileUri: url!)
        }
    }
}

SaminCli.main()


