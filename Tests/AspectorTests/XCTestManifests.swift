import XCTest

#if !os(macOS) && !os(iOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AspectorTests.allTests),
    ]
}
#endif
