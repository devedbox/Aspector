//
//  ClassTests.swift
//  ObjCRuntimeTests
//
//  Created by devedbox on 2018/8/31.
//

import XCTest
@testable import ObjCRuntime

class TestClassObject: NSObject { }

class ClassTests: XCTestCase {

    static var allTests = [
        ("testClassVer", testClassVer),
        ("testClassName", testClassName)
    ]
    
    let obj = TestClassObject()

    func testClassVer() {
        let obj = TestClassObject()
        let objc_cls: AnyClass? = object_getClass(obj)
        let cls = clazz(of: obj)
        
        XCTAssertEqual(cls.version, objc_cls.map { class_getVersion($0) })
        
        cls.set(version: 1000)
        XCTAssertEqual(cls.version, objc_cls.map { class_getVersion($0) })
        
        objc_cls.map { class_setVersion($0, 10001) }
        XCTAssertEqual(cls.version, objc_cls.map { class_getVersion($0) })
    }
    
    func testClassName() {
        let obj = TestClassObject()
        let objc_cls: AnyClass? = object_getClass(obj)
        let cls = clazz(of: obj)
        
        XCTAssertEqual(cls.name, String(cString: class_getName(objc_cls)))
        
        let another_obj = NSObject()
        XCTAssertNotEqual(cls.name, String(cString: class_getName(object_getClass(another_obj))))
    }
    
    func testSuperClass() {
        let obj = TestClassObject()
        let cls = clazz(of: obj)
        let su_cls = cls.`super`
        
        XCTAssertNotNil(su_cls)
        XCTAssertTrue(su_cls!._class == NSObject.self as AnyClass)
    }
    
    func testIsMetaClass() {
        let obj = TestClassObject()
        let cls = clazz(of: obj)
        
        XCTAssertFalse(cls.isMeta)
    }
    
    // MARK: - Private Helper.
    
    func clazz<T>(of obj: T) -> Class {
        let cls = Class(of: obj)
        XCTAssertNotNil(cls)
        return cls!
    }
}
