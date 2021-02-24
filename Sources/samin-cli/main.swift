import Foundation
import samin

class SaminCli: NSObject, StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("Event!")
    }

    func main() {
        print("SAmin as always")
        let amin = Samin()
        let profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        let data = profile.data(using: .utf8)
        let inputStream = InputStream(data: data!)
        let output = amin.parse(profileStream: inputStream)
        output.delegate = self

        while(output.streamStatus == .open) {

        }
    }
}

let app = SaminCli()
app.main()
