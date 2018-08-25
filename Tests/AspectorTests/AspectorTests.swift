import XCTest
import UIKit
@testable import Aspector

extension UIViewController {
    @objc
    func instanceFunc() {
        print(#function)
    }
    
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
        let cls = try? obj.forward(.before, selector: NSSelectorFromString("instanceFunc")) {
            print("This is a before patcher........")
        }
        let metaCls = try? UIViewController.forward(.after, selector: NSSelectorFromString("classFunc")) {
            print("This is a after patcher........of UIViewController.Type")
            throw ForwardError.duplicateSubClass(class: UIViewController.self)
        }
        
        obj.instanceFunc()
        UIViewController.classFunc()
        print(obj.perform(NSSelectorFromString("class")))
        
        try? cls?.invalid()
        try? metaCls?.invalid()
        
        obj.instanceFunc()
        UIViewController.classFunc()
        print(obj.perform(NSSelectorFromString("class")))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
