//
//  Aspect.Forward.swift
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

internal var ClassForwardsStorage: [ClassForward] = []

public struct AspectorHook {
    private let _class: AnyClass
    
    fileprivate init(class: AnyClass) {
        self._class = `class`
    }
}

public struct ClassForward {
    public let obj: AnyObject
    public let forwardedClass: AnyClass
    
    public private(set) var invocation: InvocationForward? = nil
    public private(set) var isas: [IsaForward] = []
    
    public init(_ obj: AnyObject) throws {
        self.obj = obj
        
        guard let cls = obj.perform?(NSSelectorFromString("class"))?.takeRetainedValue() as? AnyClass
            , let obj_t = object_getClass(obj)
        else {
            throw HooksError.objectGetClassFailed(object: obj)
        }
        
        if
            case let subfied? = String(cString: class_getName(obj_t), encoding: .utf8)?.hasPrefix(_SubClassPrefix),
            subfied
        {
            forwardedClass = obj_t; return
        } else if class_isMetaClass(obj_t) {
            try InvocationForward(class: obj_t).forward()
            forwardedClass = obj_t; return
        }
        
        let cls_name = _SubClassPrefix + String(cString: class_getName(obj_t))
        
        if let sub_cls = objc_getClass(cls_name.withCString { $0 }) as? AnyClass {
            object_setClass(obj, sub_cls)
            forwardedClass = sub_cls; return
        }
        
        guard let sub_cls = objc_allocateClassPair(obj_t, cls_name.withCString { $0 }, 0) else {
            throw HooksError.allocateClassPairFailed(class: obj_t)
        }
        
        invocation = InvocationForward(class: sub_cls)
        isas = [
            IsaForward(class: sub_cls, isaClass: cls),
            IsaForward(class: object_getClass(sub_cls)!, isaClass: cls)
        ]
        
        try invocation?.forward()
        try isas.forEach { try $0.forward() }
        
        objc_registerClassPair(sub_cls)
        object_setClass(obj, sub_cls)
        
        forwardedClass = sub_cls
    }
}

public struct InvocationForward {
    public let `class`: AnyClass
    
    internal func forwardInvocation(
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
    
    public func forward() throws {
        let forward_invocation_sel = NSSelectorFromString("forwardInvocation:")
        let forward_invocation_block: @convention(block) (AnyObject, AnyObject) -> Void = forwardInvocation
        let forward_invocation = imp_implementationWithBlock(unsafeBitCast(forward_invocation_block, to: AnyObject.self))
        
        guard let forward_invocation_method = _aspector_getMethod(`class`, selector: forward_invocation_sel) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: forward_invocation_sel)
        }
        
        let typeEncoding = method_getTypeEncoding(
            forward_invocation_method
        )
        
        class_addMethod( // Save.
            `class`,
            NSSelectorFromString(_AspectorForwardInvocation),
            method_getImplementation(forward_invocation_method),
            typeEncoding
        )
        
        class_replaceMethod( // Hook.
            `class`,
            forward_invocation_sel,
            forward_invocation,
            typeEncoding
        )
    }
}

public struct IsaForward {
    public let `class`: AnyClass
    public let isaClass: AnyClass
    
    internal func forwardClass(
        _ obj: AnyObject) -> AnyClass
    {
        return isaClass
    }
    
    public func forward() throws {
        let class_sel = NSSelectorFromString("class")
        
        let class_block: @convention(block) (AnyObject) -> AnyClass = forwardClass
        let class_imp = imp_implementationWithBlock(unsafeBitCast(class_block, to: AnyObject.self))
        
        guard let class_method = _aspector_getMethod(`class`, selector: class_sel) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: class_sel)
        }
        
        class_replaceMethod(
            `class`,
            class_sel,
            class_imp,
            method_getTypeEncoding(
                class_method
            )
        )
    }
}

public struct MessageForward {
    public let `class`: AnyClass
    public let selector: Selector
    
    public func forward() throws {
        guard let method = _aspector_getMethod(`class`, selector: selector) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: selector)
        }
        
        let typeEncoding = method_getTypeEncoding(
            method
        )
        
        class_addMethod(
            `class`,
            _aspector_selector(for: selector),
            method_getImplementation(method),
            typeEncoding
        )
        
        class_replaceMethod(
            `class`,
            selector,
            objc_msgForward_imp(
                `class`,
                selector
            ),
            typeEncoding
        )
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
    let clsForward = try ClassForward(obj)
    try MessageForward(class: clsForward.forwardedClass.self, selector: selector).forward()
    
    return AspectorHook(class: clsForward.forwardedClass)
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
