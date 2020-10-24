import XCTest
@testable import samin

final class saminTests: XCTestCase {

    func testCrankSamin() {
        var amin = Samin()
        var profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        var data = profile.data(using: .utf8)
        var inputStream = InputStream(data: data!)
        amin.parse(profileStream: inputStream)
    }

    func testEcho() {
        var amin = Samin()
        var profile = "<amin:profile xmlns:amin='http://projectamin.org/ns/'>\n<amin:command name=\"echo\">\n<amin:flag name=\"n\" />\n<amin:param>some string here</amin:param>\n</amin:command>\n</amin:profile>"
        var data = profile.data(using: .utf8)
        var inputStream = InputStream(data: data!)
        amin.parse(profileStream: inputStream)
    }

    static var allTests = [
        // ("testCrankSamin", testCrankSamin),
        ("testEcho", testEcho)
    ]
}
