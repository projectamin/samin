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
        var profile = ""
        var data = profile.data(using: .utf8)
        var inputStream = InputStream(data: data!)
        amin.parse(profileStream: inputStream)
    }

    func testArch() {
        var amin = Samin()
        var inputStream = InputStream(fileAtPath: "xml/arch.xml")!
        amin.parse(profileStream: inputStream)
    }

    static var allTests = [
        // ("testCrankSamin", testCrankSamin),
        ("testEcho", testEcho),
        ("testArch", testArch)
    ]
}
