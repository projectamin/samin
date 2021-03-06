import Foundation
import ArgumentParser

struct SaminCli: ParsableCommand {

    static var configuration = CommandConfiguration(
            abstract: "A commandline front end to the awesome that is Amin.",

            // Commands can define a version for automatic '--version' support.
            version: "0.0.1")

    @Option(name: [.customLong("uri"), .customShort("u")],
            help: "Process a profile at the given URI.") var uri: String?

    @Flag(name: [.customLong("profile"), .customShort("p")],
            help: "Process a profile from STDIN") var profile = false

    func run() {
        print("SAmin cause well.. 42")
        if(uri != nil) {
            print("Processing URI: \(uri!)")
            let url = URL(string: uri!)
            let scheme = url?.scheme
            if(scheme == nil) {
                print("URI must contain a scheme: http:// file:// etc.")
                return
            }
            switch (scheme) {
                case "file":
                    processUrl(uri: url!)
                    break
                case "http":
                    processUrl(uri: url!)
                    break
                default:
                    print("Unsupported URI.")
                    break
            }
        }

        if(profile) {
            let stdin = FileHandle.standardInput
            let stream = InputStream(data: stdin.availableData)
            let core = SaminCliCore()
            core.processStream(inputStream: stream)
        }
    }

    func processUrl(uri: URL) {
        let stream = InputStream(url: uri)
        let core = SaminCliCore()
        core.processStream(inputStream: stream!)
    }
}
