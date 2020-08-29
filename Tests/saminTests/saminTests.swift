import XCTest
@testable import samin

final class saminTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(samin().text, "Hello, World!")
    }

    func testCrankSamin() {
        var amin = Samin()
        var profile = "<amin:command name='mkdir' xmlns:amin='http://projectamin.org/ns/'>\n\t<amin:flag name='m'>0755</amin:flag>\n\t<amin:param name=\"target\">/tmp/test_ashell</amin:param>\n</amin:command>"
        var data = profile.data(using: .utf8)
        var inputStream = InputStream(data: data!)
        amin.parse(profileStream: inputStream)
    }

    static var allTests = [
        ("testExample", testExample),
        ("testCrankSamin", testCrankSamin)
    ]
}
