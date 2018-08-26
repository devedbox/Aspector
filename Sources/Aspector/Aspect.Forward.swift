//
//  Aspect.Forward.swift
//  Aspector
//
//  Created by devedbox on 2018/8/24.
//

import Foundation
import ObjectiveC
import _ObjC

// MARK: Error.

public enum ForwardError: Error {
    case getMethodFailed(obj: AnyObject, selector: Selector)
    case allocateClassPairFailed(class: AnyClass)
    case duplicateSubClass(class: AnyClass)
    case objectGetClassFailed(object: AnyObject)
}

private let _AspectorSubClassPrefix = "_Aspector_SubClass_"
private let _AspectorLiteral = "_aspector_"
private let _AspectorForwardInvocation = "_aspector_forwardInvocation:"

// MARK: - Hook.

public typealias ForwardPatcher = InOutPatcher<Any, Void>

@discardableResult
public func forward(
    _ obj: AnyObject,
    strategy: AspectStrategy,
    selector: Selector,
    patcher: @escaping ForwardPatcher) throws -> Forward
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
        for: obj,
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

// MARK: - Forward.

public struct Forward {
    /// The shared storage of active instance of `Forward`. Every instance of `Forward` will be stored
    /// in this container.
    internal static var Storage: [Forward] = []
    
    /// The value of instance of `ClassForward`.
    public var `class`: ClassForward
    /// The value of instance of `MessageForward`.
    public let message: MessageForward
    
    public init(
        class: ClassForward,
        message: MessageForward)
    {
        self.class = `class`
        self.message = message
    }
    
    public func invalid() throws {
        try `class`.invalid()
        try message.invalid()
        
        Forward._removeForward(
            for: `class`.object,
            selector: message.selector
        )
    }
}

// MARK: -

extension Forward {
    fileprivate static func _forward(for obj: AnyObject, selector: Selector) -> Forward? {
        return Storage.first(where: { $0.class.object === obj && $0.message.selector == selector })
    }
    
    @discardableResult
    fileprivate static func _removeForward(for obj: AnyObject, selector: Selector) -> Forward? {
        return Storage.firstIndex(where: { $0.class.object === obj && $0.message.selector == selector }).map {
            Storage.remove(at: $0)
        }
    }
}

// MARK: - ObjCRuntimeForwardable.

public protocol ObjCRuntimeForwardable {
    func forward() throws
    func invalid() throws
}

// MARK: - ClassForward.

/// A type to manage forwards of runtime message sending of the given object. For object instance,
/// `ClassForward` will generate a subclass of the class of given object and point the class of the
/// object to that class. For class instance, `ClassForward` will hook the `_objc_msgForward`
/// invocation to an instance of `InvocationForward`.
public struct ClassForward {
    /// The object or class to hook with.
    public let object: AnyObject
    /// The actual class of the hooked object.
    public let `class`: AnyClass
    
    /// The invocation forward instance of the class of given object.
    public internal(set) var invocation: InvocationForward? = nil
    /// The isa forward instance of the class of given object.
    public internal(set) var isas: [IsaForward] = []
    
    public init(
        _ obj: AnyObject) throws
    {
        self.object = obj
        
        guard let obj_cls = obj.perform?(NSSelectorFromString("class"))?.takeRetainedValue() as? AnyClass
            , let obj_t = object_getClass(obj)
        else {
            throw ForwardError.objectGetClassFailed(object: obj)
        }
        
        if
            case let obj_t_name? = String(cString: class_getName(obj_t), encoding: .utf8),
            obj_t_name.hasPrefix(_AspectorSubClassPrefix)
        {
            `class` = obj_t; return
        } else if class_isMetaClass(obj_t) {
            invocation = InvocationForward(class: obj_t)
            try invocation?.forward()
            `class` = obj_t; return
        }
        
        let obj_t_name = _AspectorSubClassPrefix + String(cString: class_getName(obj_t))
        
        if let sub_cls = objc_getClass(obj_t_name.withCString { $0 }) as? AnyClass {
            object_setClass(obj, sub_cls)
            `class` = sub_cls; return
        }
        
        guard let sub_t = objc_allocateClassPair(obj_t, obj_t_name.withCString { $0 }, 0) else {
            throw ForwardError.allocateClassPairFailed(class: obj_t)
        }
        
        invocation = InvocationForward(class: sub_t)
        isas = [
            IsaForward(class: sub_t, isaClass: obj_cls),
            IsaForward(class: object_getClass(sub_t)!, isaClass: obj_cls)
        ]
        
        try invocation?.forward()
        try isas.forEach { try $0.forward() }
        
        objc_registerClassPair(sub_t)
        object_setClass(obj, sub_t)
        
        `class` = sub_t
    }
    
    public func invalid() throws {
        try invocation?.invalid()
        // try isas.forEach { try $0.invalid() }
        
        guard let obj_t = object_getClass(object) else {
            throw ForwardError.objectGetClassFailed(object: object)
        }
        
        if
            case var obj_t_name? = String(cString: class_getName(obj_t), encoding: .utf8),
            obj_t_name.hasPrefix(_AspectorSubClassPrefix)
        {
            obj_t_name = obj_t_name.replacingOccurrences(of: _AspectorSubClassPrefix, with: "")
            if let original_obj_cls = objc_getClass(obj_t_name.withCString { $0 }) as? AnyClass {
                object_setClass(object, original_obj_cls)
            }
        }
    }
}

// MARK: - InvocationForward.

public struct InvocationForward: ObjCRuntimeForwardable {
    public let `class`: AnyClass
    
    private let forward_invocation_sel = NSSelectorFromString("forwardInvocation:")
    
    internal var befores: [ForwardPatcher] = []
    internal var afters: [ForwardPatcher] = []
    
    public init(
        class: AnyClass)
    {
        self.class = `class`
    }
    
    internal static func forwardInvocation(
        _ obj: AnyObject,
        invocation: AnyObject)
    {   
        guard let invocationClass = NSClassFromString("NSInvocation")
            , let isa = invocation.isKind?(of: invocationClass), isa
            , let asp_invocation = ASPInvocation(objcInvocation: invocation)
        else {
            return
        }
        
        let target = asp_invocation.target as AnyObject
        let selector = asp_invocation.selector
        let asp_selector = _aspector_selector(for: selector)
        
        let invocationForward = Forward._forward(
            for: obj,
            selector: selector
        )
        
        let failures = invocationForward?.class.invocation?.befores.map {
            try? $0(
                asp_invocation.arguments()
            )
        }.filter {
            $0 == nil
        }
        
        if case let isEmpty? = failures?.isEmpty, !isEmpty {
            return
        }
        
        defer {
            invocationForward?.class.invocation?.afters.forEach {
                try? $0(
                    asp_invocation.returnValue() as Any
                )
            }
        }
        
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
                obj.doesNotRecognizeSelector(
                    selector
                )
            }
        }
    }
    
    public func forward() throws {
        let block: @convention(block) (AnyObject, AnyObject) -> Void = type(of: self).forwardInvocation
        let invocation_imp = imp_implementationWithBlock(
            unsafeBitCast(
                block,
                to: AnyObject.self
            )
        )
        
        guard let method = _aspector_getMethod(`class`, selector: forward_invocation_sel) else {
            throw ForwardError.getMethodFailed(
                obj: `class`,
                selector: forward_invocation_sel
            )
        }
        
        let typeEncoding = method_getTypeEncoding(
            method
        )
        
        class_addMethod( // Save.
            `class`,
            Selector(_AspectorForwardInvocation),
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
            throw ForwardError.getMethodFailed(
                obj: `class`,
                selector: forward_invocation_sel
            )
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

// MARK: -

extension InvocationForward {
    public mutating func add(_ patcher: @escaping ForwardPatcher, for strategy: AspectStrategy) {
        switch strategy {
        case .before:
            befores.append(patcher)
        case .after:
            afters.append(patcher)
        }
    }
}

// MARK: - IsaForward.

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
            throw ForwardError.getMethodFailed(
                obj: `class`,
                selector: class_sel
            )
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
            throw ForwardError.getMethodFailed(
                obj: `class`,
                selector: class_sel
            )
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

// MARK: - MessageForward.

public struct MessageForward: ObjCRuntimeForwardable {
    public let `class`: AnyClass
    public let selector: Selector
    
    public func forward() throws {
        guard let method = _aspector_getMethod(`class`, selector: selector) else {
            throw ForwardError.getMethodFailed(
                obj: `class`,
                selector: selector
            )
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
            throw ForwardError.getMethodFailed(
                obj: `class`,
                selector: selector
            )
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

private func _aspector_selector(
    for selector: Selector) -> Selector
{
    return Selector(_AspectorLiteral + String(cString: sel_getName(selector)))
}

private func _aspector_getMethod(
    _ cls: AnyClass,
    selector: Selector) -> Method? {
    if class_isMetaClass(cls) {
        return class_getClassMethod(cls, selector)
    }
    return class_getInstanceMethod(cls, selector)
}

private func _aspector_responds_to(
    _ obj: AnyObject,
    selector: Selector) -> Bool
{
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
private func _aspector_remove_blocked_imp(
    _ obj_t: AnyClass, selector: Selector) -> Bool
{
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
