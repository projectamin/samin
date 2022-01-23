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
            let inputStream = InputStream(fileAtPath: "/dev/stdin")
            inputStream?.open()
            let amin = Samin()
            let outputStream = OutputStream()
            amin.parse(profileStream: inputStream!, outputStream: outputStream)
        }
        if(uri != nil) {
            let amin = Samin()
            let url = URL(string: uri!)
            amin.parse(profileUri: url!)
        }
    }
}

SaminCli.main()


