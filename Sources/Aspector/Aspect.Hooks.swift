//
//  Aspect.Hooks.swift
//  Aspector
//
//  Created by devedbox on 2018/8/24.
//

import Foundation
import ObjectiveC
import ObjC

// MARK: Error.

public enum HooksError: Error {
    case getMethodFailed(obj: AnyObject, selector: Selector)
    case allocateClassPairFailed(class: AnyClass)
    case duplicateSubClass(class: AnyClass)
    case objectGetClassFailed(object: AnyObject)
}

private let _IMPs_: [OpaquePointer] = []

public struct AspectorHook {
    private let _class: AnyClass
    
    fileprivate init(class: AnyClass) {
        self._class = `class`
    }
}

@objcMembers
private final class _AspectProxy {
    public func call() {
        
    }
}

private let _SubClassPrefix = "_Aspector_SubClass_"
private let _AspectorLiteral = "_aspector_"
private let _AspectorForwardInvocation = "_aspector_forwardInvocation:"

public func hook(
    _ obj: AnyObject,
    strategy: AspectStrategy,
    selector: Selector,
    patcher: Patcher<Void>) throws -> AspectorHook
{
    let cls: AnyClass = try _forwardClass(obj, selector: selector)
    try _forwardMessage(cls.self, selector: selector)
    
    return AspectorHook(class: cls)
}

private func _forwardClass(
    _ obj: AnyObject,
    selector: Selector) throws -> AnyClass
{
    guard let cls = obj.perform?(NSSelectorFromString("class"))?.takeRetainedValue() as? AnyClass
        , let obj_t = object_getClass(obj)
    else {
        throw HooksError.objectGetClassFailed(object: obj)
    }
    
    if
        case let subfied? = String(cString: class_getName(obj_t), encoding: .utf8)?.hasPrefix(_SubClassPrefix),
        subfied
    {
        return obj_t
    } else if class_isMetaClass(obj_t) {
        try _hookSavingForwardInvocationFunc(obj_t)
        return obj_t
    }
    
    let cls_name = _SubClassPrefix + String(cString: class_getName(obj_t))
    
    if let sub_cls = objc_getClass(cls_name.withCString { $0 }) as? AnyClass {
        object_setClass(obj, sub_cls)
        return sub_cls
    }
    
    guard let sub_cls = objc_allocateClassPair(obj_t, cls_name.withCString { $0 }, 0) else {
        throw HooksError.allocateClassPairFailed(class: obj_t)
    }
    
    try _hookSavingForwardInvocationFunc(sub_cls)
    try _hookSavingClassFunc(sub_cls, to: cls)
    try object_getClass(sub_cls).map { try _hookSavingClassFunc($0, to: cls) }
    
    objc_registerClassPair(sub_cls)
    object_setClass(obj, sub_cls)
    
    return sub_cls
}

private func _hookSavingForwardInvocationFunc(
    _ obj_t: AnyClass) throws
{
    let forward_invocation_sel = NSSelectorFromString("forwardInvocation:")
    let forward_invocation_block: @convention(block) (AnyObject, AnyObject) -> Void = _forwardInvocation
    let forward_invocation = imp_implementationWithBlock(unsafeBitCast(forward_invocation_block, to: AnyObject.self))
    
    guard let forward_invocation_method = _aspector_getMethod(obj_t, selector: forward_invocation_sel) else {
        throw HooksError.getMethodFailed(obj: obj_t, selector: forward_invocation_sel)
    }
    
    let typeEncoding = method_getTypeEncoding(
        forward_invocation_method
    )
    
    class_addMethod( // Save.
        obj_t,
        NSSelectorFromString(_AspectorForwardInvocation),
        method_getImplementation(forward_invocation_method),
        typeEncoding
    )
    
    class_replaceMethod( // Hook.
        obj_t,
        forward_invocation_sel,
        forward_invocation,
        typeEncoding
    )
}

private func _hookSavingClassFunc(
    _ obj_t: AnyClass,
    to cls: AnyClass) throws
{
    let class_sel = NSSelectorFromString("class")
    
    let class_block: @convention(block) (AnyObject) -> AnyClass = { obj in
        return cls
    }
    let `class` = imp_implementationWithBlock(unsafeBitCast(class_block, to: AnyObject.self))
    
    guard let class_method = _aspector_getMethod(obj_t, selector: class_sel) else {
        throw HooksError.getMethodFailed(obj: obj_t, selector: class_sel)
    }
    
    class_replaceMethod(
        obj_t,
        class_sel,
        `class`,
        method_getTypeEncoding(
            class_method
        )
    )
}

private func _forwardMessage(
    _ obj_t: AnyClass,
    selector: Selector) throws
{
    guard let method = _aspector_getMethod(obj_t, selector: selector) else {
        throw HooksError.getMethodFailed(obj: obj_t, selector: selector)
    }
    
    let typeEncoding = method_getTypeEncoding(
        method
    )
    
    class_addMethod(
        obj_t,
        _aspector_selector(for: selector),
        method_getImplementation(method),
        typeEncoding
    )
    
    class_replaceMethod(
        obj_t,
        selector,
        objc_msgForward_imp(
            obj_t,
            selector
        ),
        typeEncoding
    )
}

private func _forwardInvocation(
    _ obj: AnyObject,
    invocation: AnyObject)
{
    print(#function)
    print(obj)
    print(String(cString: class_getName(object_getClass(obj))))
    print(invocation)
    
    guard let invocationClass = NSClassFromString("NSInvocation")
        , let isa = invocation.isKind?(of: invocationClass)
        , isa
        , let asp_invocation = ASPInvocation(objcInvocation: invocation)
    else {
        return
    }
    
    let target = asp_invocation.target as AnyObject
    let selector = asp_invocation.selector
    let asp_selector = _aspector_selector(for: selector)
    
    if _aspector_responds_to(target, selector: asp_selector) {
        asp_invocation.selector = asp_selector
        asp_invocation.invoke()
    } else {
        let originalInvSel = NSSelectorFromString(_AspectorForwardInvocation)
        if _aspector_responds_to(obj, selector: originalInvSel) {
            objc_send_msgForward(
                obj,
                originalInvSel,
                invocation
            )
        } else {
            obj.doesNotRecognizeSelector(selector)
        }
    }
}

// MARK: - Helper.

private func _aspector_selector(for selector: Selector) -> Selector {
    return NSSelectorFromString(_AspectorLiteral + String(cString: sel_getName(selector)))
}

private func _aspector_getMethod(_ cls: AnyClass, selector: Selector) -> Method? {
    if class_isMetaClass(cls) {
        return class_getClassMethod(cls, selector)
    }
    return class_getInstanceMethod(cls, selector)
}

private func _aspector_responds_to(_ obj: AnyObject, selector: Selector) -> Bool {
    guard let obj_t = object_getClass(obj) else {
        return false
    }
    
    if class_isMetaClass(obj_t) {
        return obj.responds(to: selector)
    } else {
        return class_respondsToSelector(obj_t, selector)
    }
}
