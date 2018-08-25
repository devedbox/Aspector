//
//  Aspect.NSObject.swift
//  Aspect
//
//  Created by devedbox on 2018/8/23.
//

import Foundation

// MARK: - Forward.

extension NSObjectProtocol {
    @discardableResult
    public func forward(
        _ strategy: AspectStrategy,
        selector: Selector,
        patcher: @escaping ForwardPatcher) throws -> Forward
    {
        return try Aspector.forward(
            self,
            strategy: strategy,
            selector: selector,
            patcher: patcher
        )
    }
    
    @discardableResult
    public static func forward(
        _ strategy: AspectStrategy,
        selector: Selector,
        patcher: @escaping ForwardPatcher) throws -> Forward
    {
        return try Aspector.forward(
            self,
            strategy: strategy,
            selector: selector,
            patcher: patcher
        )
    }
}

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
    public func isEqual(_ object: Any?, patcher: Patcher<Any?>) rethrows -> Bool {
        return try _dispatch(self, patcher: patcher) { obj.isEqual( $0 ?? object) }
    }
    
    public func hash(patcher: Patcher<Void>) rethrows -> Int {
        return  try _dispatch(self, patcher: patcher) { _ in obj.hash }
    }
    
    public func superclass(patcher: Patcher<Void>) rethrows -> AnyClass? {
        return try _dispatch(self, patcher: patcher) { _ in obj.superclass }
    }
    
    public func `self`(patcher: Patcher<Void>) rethrows -> T {
        return try _dispatch(self, patcher: patcher) { _ in obj }
    }
    
    public func perform(
        _ aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows -> Unmanaged<AnyObject>?
    {
        return try _dispatch(self, patcher: patcher) { obj.perform($0 ?? aSelector) }
    }
    
    public func perform(
        _ aSelector: Selector?,
        with object: Any?,
        patcher: Patcher<(Selector?, Any?)>) rethrows -> Unmanaged<AnyObject>?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.perform($0?.0 ?? aSelector, with: $0?.1 ?? object)
        }
    }
    
    public func perform(
        _ aSelector: Selector?,
        with object1: Any?,
        with object2: Any?,
        patcher: Patcher<(Selector?, Any?, Any?)>) rethrows -> Unmanaged<AnyObject>?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.perform($0?.0 ?? aSelector,
                        with: $0?.1 ?? object1,
                        with: $0?.2 ?? object2)
        }
    }
    
    public func isProxy(patcher: Patcher<Void>) rethrows -> Bool {
        return try _dispatch(self, patcher: patcher) { _ in obj.isProxy() }
    }
    
    public func isKind(
        of aClass: AnyClass,
        patcher: Patcher<AnyClass>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.isKind(of: $0 ?? aClass)
        }
    }
    
    public func isMember(
        of aClass: AnyClass,
        patcher: Patcher<AnyClass>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.isMember(of: $0 ?? aClass)
        }
    }
    
    public func conforms(
        to aProtocol: Protocol,
        patcher: Patcher<Protocol>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.conforms(to: $0 ?? aProtocol)
        }
    }
    
    public func responds(
        to aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.responds(to: $0 ?? aSelector)
        }
    }
    
    public func description(patcher: Patcher<Void>) rethrows -> String {
        return try _dispatch(self, patcher: patcher) { _ in obj.description }
    }
    
    public func debugDescription(patcher: Patcher<Void>) rethrows -> String? {
        return try _dispatch(self, patcher: patcher) { _ in obj.debugDescription }
    }
}

// MARK: - NSObject.Type.

extension MetaAspect where T: NSObject {
    public func load(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in
            obj.load()
        }
    }
    
    public func initialize(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in
            obj.initialize()
        }
    }
    
    public func instancesRespond(
        to aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.instancesRespond(to: $0 ?? aSelector)
        }
    }
    
    public func conforms(
        to protocol: Protocol,
        patcher: Patcher<Protocol>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.conforms(to: $0 ?? `protocol`)
        }
    }
    
    public func instanceMethod(
        for aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows -> IMP?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.instanceMethod(for: $0 ?? aSelector)
        }
    }
    
    public func isSubclass(
        of aClass: AnyClass,
        patcher: Patcher<AnyClass>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.isSubclass(of: $0 ?? aClass)
        }
    }
    
    @available(iOS 2.0, *)
    public func resolveClassMethod(
        _ sel: Selector?,
        patcher: Patcher<Selector?>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.resolveClassMethod($0 ?? sel)
        }
    }
    
    @available(iOS 2.0, *)
    public func resolveInstanceMethod(
        _ sel: Selector?,
        patcher: Patcher<Selector?>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.resolveInstanceMethod($0 ?? sel)
        }
    }
    
    public func hash(patcher: Patcher<Void>) rethrows -> Int {
        return try _dispatch(self, patcher: patcher) { _ in obj.hash() }
    }
    
    public func superclass(patcher: Patcher<Void>) rethrows -> AnyClass? {
        return try _dispatch(self, patcher: patcher) { _ in obj.superclass() }
    }
    
    public func description(patcher: Patcher<Void>) rethrows -> String {
        return try _dispatch(self, patcher: patcher) { _ in obj.description() }
    }
    
    public func debugDescription(patcher: Patcher<Void>) rethrows -> String {
        return try _dispatch(self, patcher: patcher) { _ in obj.debugDescription() }
    }
    
    public func cancelPreviousPerformRequests(
        withTarget aTarget: Any,
        patcher: Patcher<Any>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.cancelPreviousPerformRequests(withTarget: $0 ?? aTarget)
        }
    }
    
    public func cancelPreviousPerformRequests(
        withTarget aTarget: Any,
        selector aSelector: Selector,
        object anArgument: Any?,
        patcher: Patcher<(Any, Selector, Any?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.cancelPreviousPerformRequests(withTarget: $0?.0 ?? aTarget,
                                              selector: $0?.1 ?? aSelector,
                                              object: $0?.2 ?? anArgument)
        }
    }
}

// MARK: - NSObject.

extension Aspect where T: NSObject {
    
    public func copy(patcher: Patcher<Void>) rethrows -> Any {
        return try _dispatch(self, patcher: patcher) { _ in
            obj.copy()
        }
    }
    
    public func mutableCopy(patcher: Patcher<Void>) rethrows -> Any {
        return try _dispatch(self, patcher: patcher) { _ in
            obj.mutableCopy()
        }
    }
    
    public func method(
        for aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows -> IMP?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.method(for: $0 ?? aSelector)
        }
    }
    
    public func doesNotRecognizeSelector(
        _ aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.doesNotRecognizeSelector($0 ?? aSelector)
        }
    }
    
    public func autoContentAccessingProxy(
        patcher: Patcher<Void>) rethrows -> Any
    {
        return try _dispatch(self, patcher: patcher) { _ in
            obj.autoContentAccessingProxy
        }
    }
    
    @available(iOS 2.0, *)
    public func forwardingTarget(
        for aSelector: Selector?,
        patcher: Patcher<Selector?>) rethrows -> Any?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.forwardingTarget(for: $0 ?? aSelector)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        with anArgument: Any?,
        afterDelay delay: TimeInterval,
        patcher: Patcher<(Selector, Any?, TimeInterval)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.perform($0?.0 ?? aSelector,
                        with: $0?.1 ?? anArgument,
                        afterDelay: $0?.2 ?? delay)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        with anArgument: Any?,
        afterDelay delay: TimeInterval,
        inModes modes: [RunLoop.Mode],
        patcher: Patcher<(Selector, Any?, TimeInterval, [RunLoop.Mode])>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.perform($0?.0 ?? aSelector,
                        with: $0?.1 ?? anArgument,
                        afterDelay: $0?.2 ?? delay,
                        inModes: $0?.3 ?? modes)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        on thr: Thread,
        with arg: Any?,
        waitUntilDone wait: Bool,
        patcher: Patcher<(Selector, Thread, Any?, Bool)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.perform($0?.0 ?? aSelector,
                        on: $0?.1 ?? thr,
                        with: $0?.2 ?? arg,
                        waitUntilDone: $0?.3 ?? wait)
        }
    }
    
    public func perform(
        _ aSelector: Selector,
        on thr: Thread,
        with arg: Any?,
        waitUntilDone wait: Bool,
        modes array: [String]?,
        patcher: Patcher<(Selector, Thread, Any?, Bool, [String]?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.perform($0?.0 ?? aSelector,
                        on: $0?.1 ?? thr,
                        with: $0?.2 ?? arg,
                        waitUntilDone: $0?.3 ?? wait,
                        modes: $0?.4 ?? array)
        }
    }
    
    public func performSelector(
        onMainThread aSelector: Selector,
        with arg: Any?,
        waitUntilDone wait: Bool,
        patcher: Patcher<(Selector, Any?, Bool)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.performSelector(onMainThread: $0?.0 ?? aSelector,
                                with: $0?.1 ?? arg,
                                waitUntilDone: $0?.2 ?? wait)
        }
    }
    
    public func performSelector(
        onMainThread aSelector: Selector,
        with arg: Any?,
        waitUntilDone wait: Bool,
        modes array: [String]?,
        patcher: Patcher<(Selector, Any?, Bool, [String]?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.performSelector(onMainThread: $0?.0 ?? aSelector,
                                with: $0?.1 ?? arg,
                                waitUntilDone: $0?.2 ?? wait,
                                modes: $0?.3 ?? array)
        }
    }
    
    public func performSelector(
        inBackground aSelector: Selector,
        with arg: Any?,
        patcher: Patcher<(Selector, Any?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.performSelector(inBackground: $0?.0 ?? aSelector,
                                with: $0?.1 ?? arg)
        }
    }
}
