import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(saminTests.allTests),
        testCase(AminWriterTests.allTests)
    ]
}
#endif
