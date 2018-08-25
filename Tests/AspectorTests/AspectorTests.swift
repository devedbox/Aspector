import XCTest
import UIKit
@testable import Aspector

extension UIViewController {
    @objc
    class func classFunc() {
        print(#function)
    }
}

final class AspectorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        /*
        let obj = NSObject()
        print(obj.aspect(.before).isEqual(obj) {
            print("isEqual")
        })
        print(obj.aspect(.after).isMember(of: type(of: obj)) {
            print("isMember")
        })
        obj.aspect(.after).isEqual(obj) {
            
        }
         */
    }
    
    func testHooks() {
        let obj = UIViewController()
        let cls = try! hook(obj, strategy: .before, selector: NSSelectorFromString("loadView"), patcher: { nil })
        let metaCls = try! hook(UIViewController.self, strategy: .before, selector: NSSelectorFromString("classFunc"), patcher: { nil })
        print(cls)
        print(metaCls)
        obj.loadView()
        UIViewController.classFunc()
        print(obj.perform(NSSelectorFromString("class")))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
