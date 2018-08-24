//
//  Aspect.Hooks.swift
//  Aspector
//
//  Created by devedbox on 2018/8/24.
//

import Foundation
import ObjectiveC

// MARK: Error.

public enum HooksError: Error {
    case getInstanceMethodFailed(selector: Selector)
}

private let _IMPs_: [OpaquePointer] = []

public struct AspectorHook {
    
}

public func hook<T: AnyObject>(
    _ objc_t: T.Type,
    strategy: AspectStrategy,
    selector: Selector,
    patcher: Patcher<Void>) throws -> AspectorHook
{
    guard let method = class_getInstanceMethod(objc_t, selector) else {
        throw HooksError.getInstanceMethodFailed(selector: selector)
    }
    
    let impl = method_getImplementation(method)
    
    
    return AspectorHook()
}
