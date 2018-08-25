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

private let _SubClassPrefix = "_Aspector_SubClass_"
private let _AspectorLiteral = "_aspector_"
private let _AspectorForwardInvocation = "_aspector_forwardInvocation:"

public func hook(
    _ obj: AnyObject,
    strategy: AspectStrategy,
    selector: Selector,
    patcher: @escaping Patcher<Void>) throws -> Forward
{
    var forward = Forward._forward(for: obj, selector: selector)
    
    if forward == nil {
        let clsForward = try ClassForward(obj)
        let msgForward = MessageForward(
            class: clsForward.class.self,
            selector: selector
        )
        
        try msgForward.forward()
        
        forward = Forward(
            class: clsForward,
            message: msgForward
        )
    }
    
    Forward._removeForward(
        for: forward as AnyObject,
        selector: selector
    )
    
    forward?.class.invocation?.add(
        patcher,
        for: strategy
    )
    
    Forward.Storage.append(
        forward!
    )
    
    return forward!
}

public struct Forward {
    internal static var Storage: [Forward] = []
    
    public var `class`: ClassForward
    public let message: MessageForward
    
    public init(class: ClassForward, message: MessageForward) {
        self.class = `class`
        self.message = message
    }
    
    public func invalid() throws {
        try `class`.invalid()
        try message.invalid()
        
        Forward._removeForward(
            for: `class`.obj,
            selector: message.selector
        )
    }
}

extension Forward {
    fileprivate static func _forward(for obj: AnyObject, selector: Selector) -> Forward? {
        return Storage.first(where: { $0.class.obj === obj && $0.message.selector == selector })
    }
    
    @discardableResult
    fileprivate static func _removeForward(for obj: AnyObject, selector: Selector) -> Forward? {
        return Storage.firstIndex(where: { $0.class.obj === obj && $0.message.selector == selector }).map {
            Storage.remove(at: $0)
        }
    }
}

public protocol ObjCRuntimeForwardable {
    func forward() throws
    func invalid() throws
}

public struct ClassForward {
    public let obj: AnyObject
    public let `class`: AnyClass
    
    public internal(set) var invocation: InvocationForward? = nil
    public internal(set) var isas: [IsaForward] = []
    
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
            `class` = obj_t; return
        } else if class_isMetaClass(obj_t) {
            invocation = InvocationForward(class: obj_t)
            try invocation?.forward()
            `class` = obj_t; return
        }
        
        let cls_name = _SubClassPrefix + String(cString: class_getName(obj_t))
        
        if let sub_cls = objc_getClass(cls_name.withCString { $0 }) as? AnyClass {
            object_setClass(obj, sub_cls)
            `class` = sub_cls; return
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
        
        `class` = sub_cls
    }
    
    public func invalid() throws {
        try invocation?.invalid()
        // try isas.forEach { try $0.invalid() }
        
        guard let obj_t = object_getClass(obj) else {
            throw HooksError.objectGetClassFailed(object: obj)
        }
        
        if
            case var cls_name? = String(cString: class_getName(obj_t), encoding: .utf8),
            cls_name.hasPrefix(_SubClassPrefix)
        {
            cls_name = cls_name.replacingOccurrences(of: _SubClassPrefix, with: "")
            if let original_cls = objc_getClass(cls_name.withCString { $0 }) as? AnyClass {
                object_setClass(obj, original_cls)
            }
        }
    }
}

public struct InvocationForward: ObjCRuntimeForwardable {
    public let `class`: AnyClass
    
    private let forward_invocation_sel = NSSelectorFromString("forwardInvocation:")
    
    internal var befores: [Patcher<Void>] = []
    internal var afters: [Patcher<Void>] = []
    
    public init(class: AnyClass) {
        self.class = `class`
    }
    
    internal func forwardInvocation(
        _ obj: AnyObject,
        invocation: AnyObject)
    {   
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
        
        let invocationForward = Forward.Storage.first(
            where: { $0.class.obj === obj && $0.message.selector == selector }
        )
        
        do {
            try invocationForward?.class.invocation?.befores.forEach { try $0() }
        } catch _ { return }
        
        if _aspector_responds_to(target, selector: asp_selector) {
            asp_invocation.selector = asp_selector
            asp_invocation.invoke()
            
            do {
                try invocationForward?.class.invocation?.afters.forEach { try $0() }
            } catch _ { return }
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
        let block: @convention(block) (AnyObject, AnyObject) -> Void = forwardInvocation
        let invocation_imp = imp_implementationWithBlock(unsafeBitCast(block, to: AnyObject.self))
        
        guard let method = _aspector_getMethod(`class`, selector: forward_invocation_sel) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: forward_invocation_sel)
        }
        
        let typeEncoding = method_getTypeEncoding(
            method
        )
        
        class_addMethod( // Save.
            `class`,
            NSSelectorFromString(_AspectorForwardInvocation),
            method_getImplementation(method),
            typeEncoding
        )
        
        class_replaceMethod( // Hook.
            `class`,
            forward_invocation_sel,
            invocation_imp,
            typeEncoding
        )
    }
    
    public func invalid() throws {
        _aspector_remove_blocked_imp(
            `class`,
            selector: forward_invocation_sel
        )
        
        let selector = _aspector_selector(for: forward_invocation_sel)
        guard let method = _aspector_getMethod(`class`, selector: selector) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: forward_invocation_sel)
        }
        
        class_replaceMethod(
            `class`,
            forward_invocation_sel,
            method_getImplementation(
                method
            ),
            method_getTypeEncoding(
                method
            )
        )
    }
}

extension InvocationForward {
    public mutating func add(_ patcher: @escaping Patcher<Void>, for strategy: AspectStrategy) {
        switch strategy {
        case .before:
            befores.append(patcher)
        case .after:
            afters.append(patcher)
        }
    }
}

public struct IsaForward: ObjCRuntimeForwardable {
    public let `class`: AnyClass
    public let isaClass: AnyClass
    
    private let class_sel = NSSelectorFromString("class")
    
    internal func forwardClass(
        _ obj: AnyObject) -> AnyClass
    {
        return isaClass
    }
    
    public func forward() throws {
        let class_block: @convention(block) (AnyObject) -> AnyClass = forwardClass
        let class_imp = imp_implementationWithBlock(unsafeBitCast(class_block, to: AnyObject.self))
        
        guard let class_method = _aspector_getMethod(`class`, selector: class_sel) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: class_sel)
        }
        
        let typeEncoding = method_getTypeEncoding(
            class_method
        )
        
        class_addMethod(
            `class`,
            _aspector_selector(
                for: class_sel
            ),
            method_getImplementation(
                class_method
            ),
            typeEncoding
        )
        
        class_replaceMethod(
            `class`,
            class_sel,
            class_imp,
            typeEncoding
        )
    }
    
    public func invalid() throws {
        _aspector_remove_blocked_imp(
            `class`,
            selector: class_sel
        )
        
        let selector = _aspector_selector(for: class_sel)
        guard let method = _aspector_getMethod(`class`, selector: selector) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: class_sel)
        }
        
        class_replaceMethod(
            `class`,
            class_sel,
            method_getImplementation(
                method
            ),
            method_getTypeEncoding(
                method
            )
        )
    }
}

public struct MessageForward: ObjCRuntimeForwardable {
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
    
    public func invalid() throws {
        guard let method = _aspector_getMethod(`class`, selector: _aspector_selector(for: selector)) else {
            throw HooksError.getMethodFailed(obj: `class`, selector: selector)
        }
        
        class_replaceMethod(
            `class`,
            selector,
            method_getImplementation(
                method
            ),
            method_getTypeEncoding(
                method
            )
        )
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

@discardableResult
private func _aspector_remove_blocked_imp(_ obj_t: AnyClass, selector: Selector) -> Bool {
    let forward_method = _aspector_getMethod(
        obj_t,
        selector: selector
    )
    let forward_imp = forward_method.flatMap {
        method_getImplementation($0)
    }
    return forward_imp.map {
        imp_removeBlock($0)
    } ?? false
}
