import XCTest

import AspectTests

var tests = [XCTestCaseEntry]()
tests += AspectTests.allTests()
XCTMain(tests)