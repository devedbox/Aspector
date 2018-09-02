//
//  MethodIMPTests.swift
//  ObjCRuntimeTests
//
//  Created by devedbox on 2018/8/31.
//

import XCTest
@testable import ObjCRuntime

class MethodIMPTests: XCTestCase {
    static var allTests = [
        ("testExample", testExample)
    ]
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let imp = Method.IMP() { (str: AnyObject) -> AnyObject in
            return str
        }
        XCTAssertNotNil(imp)
    }
}
