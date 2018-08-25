import XCTest
import UIKit
@testable import Aspector

extension UIViewController {
    @objc
    func instanceFunc(_ arg: Int) -> Int {
        print(#function)
        return arg
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
        let cls = try? obj.forward(.before, selector: #selector(UIViewController.instanceFunc(_:))) {
            print("This is a before patcher........, arguments: \($0)")
        }
        _ = try? obj.forward(.after, selector: #selector(UIViewController.instanceFunc(_:))) {
            print("This is a after patcher........, return value: \($0)")
        }
        let metaCls = try? UIViewController.forward(.after, selector: #selector(UIViewController.classFunc)) {
            print("This is a after patcher........of UIViewController.Type, returned value: \($0)")
            throw ForwardError.duplicateSubClass(class: UIViewController.self)
        }
        _ = try? UIViewController.forward(.before, selector: #selector(UIViewController.classFunc)) {
            print("This is a before patcher........of UIViewController.Type, args value: \($0)")
        }
        
        _ = obj.instanceFunc(2)
        UIViewController.classFunc()
        print(obj.perform(NSSelectorFromString("class")))
        
        try? cls?.invalid()
        try? metaCls?.invalid()
        
        _ = obj.instanceFunc(1)
        UIViewController.classFunc()
        print(obj.perform(NSSelectorFromString("class")))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
