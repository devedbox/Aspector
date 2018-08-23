//
//  Aspect.NSObject.swift
//  Aspect
//
//  Created by devedbox on 2018/8/23.
//

import Foundation

// MARK: - Aspector.

extension NSObject {
    public func aspect(_ strategy: AspectStrategy) -> Aspect<NSObject> {
        return Aspector.aspect(self, strategy: strategy)
    }
    
    public class func aspect(_ strategy: AspectStrategy) -> MetaAspect<NSObject> {
        return Aspector.aspect(self, strategy: strategy)
    }
}

// MARK: - NSObjectProtocol.

extension Aspect where T: NSObjectProtocol {
    public func isEqual(_ object: Any?, patcher: Patcher) -> Bool {
        return dispatch(self, patcher: patcher) { obj.isEqual(object) }
    }
    
    public func hash(patcher: Patcher) -> Int {
        return dispatch(self, patcher: patcher) { obj.hash }
    }
    
    public func superclass(patcher: Patcher) -> AnyClass? {
        return dispatch(self, patcher: patcher) { obj.superclass }
    }
    
    public func `self`(patcher: Patcher) -> T {
        return dispatch(self, patcher: patcher) { obj }
    }
    
    public func perform(
        _ aSelector: Selector?,
        patcher: Patcher) -> Unmanaged<AnyObject>?
    {
        return dispatch(self, patcher: patcher) { obj.perform(aSelector) }
    }
    
    public func perform(
        _ aSelector: Selector?,
        with object: Any?,
        patcher: Patcher) -> Unmanaged<AnyObject>?
    {
        return dispatch(self, patcher: patcher) {
            obj.perform(aSelector, with: object)
        }
    }
    
    public func perform(
        _ aSelector: Selector?,
        with object1: Any?,
        with object2: Any?,
        patcher: Patcher) -> Unmanaged<AnyObject>?
    {
        return dispatch(self, patcher: patcher) {
            obj.perform(aSelector,
                        with: object1,
                        with: object2)
        }
    }
    
    public func isProxy(patcher: Patcher) -> Bool {
        return dispatch(self, patcher: patcher) { obj.isProxy() }
    }
    
    public func isKind(
        of aClass: AnyClass,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.isKind(of: aClass)
        }
    }
    
    public func isMember(
        of aClass: AnyClass,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.isMember(of: aClass)
        }
    }
    
    public func conforms(
        to aProtocol: Protocol,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.conforms(to: aProtocol)
        }
    }
    
    public func responds(
        to aSelector: Selector?,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.responds(to: aSelector)
        }
    }
    
    public func description(patcher: Patcher) -> String {
        return dispatch(self, patcher: patcher) { obj.description }
    }
    
    public func debugDescription(patcher: Patcher) -> String? {
        return dispatch(self, patcher: patcher) { obj.debugDescription }
    }
}

// MARK: - NSObject.Type.

extension MetaAspect where T: NSObject {
    public func load(patcher: Patcher) {
        dispatch(self, patcher: patcher) {
            obj.load()
        }
    }
    
    public func initialize(patcher: Patcher) {
        dispatch(self, patcher: patcher) {
            obj.initialize()
        }
    }
    
    public func instancesRespond(
        to aSelector: Selector!,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.instancesRespond(to: aSelector)
        }
    }
    
    public func conforms(
        to protocol: Protocol,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.conforms(to: `protocol`)
        }
    }
    
    public func instanceMethod(
        for aSelector: Selector?,
        patcher: Patcher) -> IMP?
    {
        return dispatch(self, patcher: patcher) {
            obj.instanceMethod(for: aSelector)
        }
    }
    
    public func isSubclass(
        of aClass: AnyClass,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.isSubclass(of: aClass)
        }
    }
    
    @available(iOS 2.0, *)
    public func resolveClassMethod(
        _ sel: Selector?,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.resolveClassMethod(sel)
        }
    }
    
    @available(iOS 2.0, *)
    public func resolveInstanceMethod(
        _ sel: Selector?,
        patcher: Patcher) -> Bool
    {
        return dispatch(self, patcher: patcher) {
            obj.resolveInstanceMethod(sel)
        }
    }
    
    public func hash(patcher: Patcher) -> Int {
        return dispatch(self, patcher: patcher) { obj.hash() }
    }
    
    public func superclass(patcher: Patcher) -> AnyClass? {
        return dispatch(self, patcher: patcher) { obj.superclass() }
    }
    
    public func description(patcher: Patcher) -> String {
        return dispatch(self, patcher: patcher) { obj.description() }
    }
    
    public func debugDescription(patcher: Patcher) -> String {
        return dispatch(self, patcher: patcher) { obj.debugDescription() }
    }
    
    public func cancelPreviousPerformRequests(
        withTarget aTarget: Any,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.cancelPreviousPerformRequests(withTarget: aTarget)
        }
    }
    
    public func cancelPreviousPerformRequests(
        withTarget aTarget: Any,
        selector aSelector: Selector,
        object anArgument: Any?,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.cancelPreviousPerformRequests(withTarget: aTarget,
                                              selector: aSelector,
                                              object: anArgument)
        }
    }
}

// MARK: - NSObject.

extension Aspect where T: NSObject {
    
    public func copy(patcher: Patcher) -> Any {
        return dispatch(self, patcher: patcher) {
            obj.copy()
        }
    }
    
    public func mutableCopy(patcher: Patcher) -> Any {
        return dispatch(self, patcher: patcher) {
            obj.mutableCopy()
        }
    }
    
    public func method(
        for aSelector: Selector?,
        patcher: Patcher) -> IMP?
    {
        return dispatch(self, patcher: patcher) {
            obj.method(for: aSelector)
        }
    }
    
    public func doesNotRecognizeSelector(
        _ aSelector: Selector?,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.doesNotRecognizeSelector(aSelector)
        }
    }
    
    public func autoContentAccessingProxy(patcher: Patcher) -> Any {
        return dispatch(self, patcher: patcher) {
            obj.autoContentAccessingProxy
        }
    }
    
    @available(iOS 2.0, *)
    public func forwardingTarget(
        for aSelector: Selector?,
        patcher: Patcher) -> Any?
    {
        return dispatch(self, patcher: patcher) {
            obj.forwardingTarget(for: aSelector)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        with anArgument: Any?,
        afterDelay delay: TimeInterval,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.perform(aSelector,
                        with: anArgument,
                        afterDelay: delay)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        with anArgument: Any?,
        afterDelay delay: TimeInterval,
        inModes modes: [RunLoop.Mode],
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
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
        waitUntilDone wait: Bool,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
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
        modes array: [String]?,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
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
        waitUntilDone wait: Bool,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.performSelector(onMainThread: aSelector,
                                with: arg,
                                waitUntilDone: wait)
        }
    }
    
    public func performSelector(
        onMainThread aSelector: Selector,
        with arg: Any?,
        waitUntilDone wait: Bool,
        modes array: [String]?,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.performSelector(onMainThread: aSelector,
                                with: arg,
                                waitUntilDone: wait,
                                modes: array)
        }
    }
    
    public func performSelector(
        inBackground aSelector: Selector,
        with arg: Any?,
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.performSelector(inBackground: aSelector,
                                with: arg)
        }
    }
}
