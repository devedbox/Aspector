//
//  Aspect.NSObject.swift
//  Aspect
//
//  Created by devedbox on 2018/8/23.
//

import Foundation

// MARK: - Dispatch.

extension Aspect where T: NSObjectProtocol {
    internal func dispatch<R>(_ dispatcher: () -> R) -> R {
        switch strategy {
        case .before:
            exe(); return dispatcher();
        case .after:
            let result = dispatcher(); exe(); return result
        }
    }
    
    internal func dispatch<R>(_ strategy: Strategy, aspecter: () -> Void, dispatcher: () -> R) -> R {
        switch strategy {
        case .before:
            aspecter(); return dispatcher()
        case .after:
            let r = dispatcher(); aspecter(); return r
        }
    }
}

// MARK: - NSObject.

extension NSObject {
    public func before(_ aspecter: @escaping () -> Void) -> Aspect<NSObject> {
        return Aspect<NSObject>(.before, self, exe: aspecter)
    }
    
    public func after(_ aspecter: @escaping () -> Void) -> Aspect<NSObject> {
        return Aspect<NSObject>(.after, self, exe: aspecter)
    }
    
    public class func before(_ aspecter: @escaping () -> Void) -> Aspect<NSObject.Type> {
        return Aspect<NSObject.Type>(.before, self, exe: aspecter)
    }
    
    public class func after(_ aspecter: @escaping () -> Void) -> Aspect<NSObject.Type> {
        return Aspect<NSObject.Type>(.after, self, exe: aspecter)
    }
}

// MARK: - NSObjectProtocol.

extension Aspect where T: NSObjectProtocol {
    public func isEqual(_ object: Any?) -> Bool {
        return dispatch {
            obj.isEqual(object)
        }
    }
    
    public var hash: Int {
        return dispatch { obj.hash }
    }
    
    public var superclass: AnyClass? {
        return dispatch { obj.superclass }
    }
    
    public func `self`() -> T {
        return dispatch { obj }
    }
    
    public func perform(
        _ aSelector: Selector?) -> Unmanaged<AnyObject>?
    {
        return dispatch {
            obj.perform(aSelector)
        }
    }
    
    public func perform(
        _ aSelector: Selector?,
        with object: Any?) -> Unmanaged<AnyObject>?
    {
        return dispatch {
            obj.perform(aSelector,
                        with: object)
        }
    }
    
    public func perform(
        _ aSelector: Selector?,
        with object1: Any?,
        with object2: Any?) -> Unmanaged<AnyObject>?
    {
        return dispatch {
            obj.perform(aSelector,
                        with: object1,
                        with: object2)
        }
    }
    
    public func isProxy() -> Bool { return dispatch { obj.isProxy() } }
    
    public func isKind(
        of aClass: AnyClass) -> Bool
    {
        return dispatch {
            obj.isKind(of: aClass)
        }
    }
    
    public func isMember(
        of aClass: AnyClass) -> Bool
    {
        return dispatch {
            obj.isMember(of: aClass)
        }
    }
    
    public func conforms(
        to aProtocol: Protocol) -> Bool
    {
        return dispatch {
            obj.conforms(to: aProtocol)
        }
    }
    
    public func responds(
        to aSelector: Selector?) -> Bool
    {
        return dispatch {
            obj.responds(to: aSelector)
        }
    }
    
    public var description: String {
        return dispatch { obj.description }
    }
    
    public var debugDescription: String? {
        return dispatch { obj.debugDescription }
    }
}

// MARK: - NSObject.Type.

extension Aspect where T == NSObject.Type {
    
}

// MARK: - NSObject.

extension Aspect where T: NSObject {
    public static func load() {
        #warning ("load")
    }
    
    public static func initialize() {
        #warning ("initialize")
    }
    
    public func copy() -> Any {
        return dispatch {
            obj.copy()
        }
    }
    
    public func mutableCopy() -> Any {
        return dispatch {
            obj.mutableCopy()
        }
    }
    
    public static func instancesRespond(
        to aSelector: Selector!) -> Bool
    {
        #warning ("instancesRespond")
        return false
    }
    
    public static func conforms(
        to protocol: Protocol) -> Bool
    {
        #warning ("instancesRespond")
        return false
    }
    
    public func method(
        for aSelector: Selector?) -> IMP?
    {
        return dispatch {
            obj.method(for: aSelector)
        }
    }
    
    public static func instanceMethod(
        for aSelector: Selector?) -> IMP?
    {
        #warning ("instanceMethod")
        return nil
    }
    
    public func doesNotRecognizeSelector(
        _ aSelector: Selector?)
    {
        dispatch {
            obj.doesNotRecognizeSelector(aSelector)
        }
    }
    
    @available(iOS 2.0, *)
    public func forwardingTarget(
        for aSelector: Selector?) -> Any?
    {
        return dispatch {
            obj.forwardingTarget(for: aSelector)
        }
    }
    
    public static func isSubclass(of aClass: AnyClass) -> Bool {
        #warning ("isSubclass")
        return false
    }
    
    @available(iOS 2.0, *)
    public static func resolveClassMethod(_ sel: Selector?) -> Bool {
        #warning ("resolveClassMethod")
        return false
    }
    
    @available(iOS 2.0, *)
    public static func resolveInstanceMethod(_ sel: Selector?) -> Bool {
        #warning ("resolveInstanceMethod")
        return false
    }
    
    public static func hash() -> Int {
        #warning ("hash")
        return 0
    }
    
    public static func superclass() -> AnyClass? {
        #warning ("superclass")
        return T.superclass()
    }
    
    public static func description() -> String {
        #warning ("description")
        return T.description()
    }
    
    public static func debugDescription() -> String {
        #warning ("debugDescription")
        return T.debugDescription()
    }
    
    public var autoContentAccessingProxy: Any {
        return dispatch {
            obj.autoContentAccessingProxy
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        with anArgument: Any?,
        afterDelay delay: TimeInterval)
    {
        dispatch {
            obj.perform(aSelector,
                        with: anArgument,
                        afterDelay: delay)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        with anArgument: Any?,
        afterDelay delay: TimeInterval,
        inModes modes: [RunLoop.Mode])
    {
        dispatch {
            obj.perform(aSelector,
                        with: anArgument,
                        afterDelay: delay,
                        inModes: modes)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        on thr: Thread,
        with arg: Any?,
        waitUntilDone wait: Bool)
    {
        dispatch {
            obj.perform(aSelector,
                        on: thr,
                        with: arg,
                        waitUntilDone: wait)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        on thr: Thread,
        with arg: Any?,
        waitUntilDone wait: Bool,
        modes array: [String]?)
    {
        dispatch {
            obj.perform(aSelector,
                        on: thr,
                        with: arg,
                        waitUntilDone: wait,
                        modes: array)
        }
    }
    
    public func performSelector(
        onMainThread aSelector: Selector,
        with arg: Any?,
        waitUntilDone wait: Bool)
    {
        dispatch {
            obj.performSelector(onMainThread: aSelector,
                                with: arg,
                                waitUntilDone: wait)
        }
    }
    
    public func performSelector(
        onMainThread aSelector: Selector,
        with arg: Any?,
        waitUntilDone wait: Bool,
        modes array: [String]?)
    {
        dispatch {
            obj.performSelector(onMainThread: aSelector,
                                with: arg,
                                waitUntilDone: wait,
                                modes: array)
        }
    }
    
    public func performSelector(
        inBackground aSelector: Selector,
        with arg: Any?)
    {
        dispatch {
            obj.performSelector(inBackground: aSelector,
                                with: arg)
        }
    }
    
    public static func cancelPreviousPerformRequests(
        withTarget aTarget: Any)
    {
        #warning ("cancelPreviousPerformRequests")
        T.cancelPreviousPerformRequests(withTarget: aTarget)
    }
    
    public static func cancelPreviousPerformRequests(
        withTarget aTarget: Any,
        selector aSelector: Selector,
        object anArgument: Any?)
    {
        #warning ("cancelPreviousPerformRequests")
        T.cancelPreviousPerformRequests(withTarget: aTarget,
                                        selector: aSelector,
                                        object: anArgument)
    }
}
