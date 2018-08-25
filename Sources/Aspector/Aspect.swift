//
// Aspect.swift
// Aspect
//
// Created by devedbox.
//

import Foundation
import UIKit

// MARK: - AspectStrategy.

public enum AspectStrategy {
    case before
    case after
}

// MARK: - Aspectable.

public typealias InOutPatcher<I, O> = (I) throws -> O
public typealias Patcher<T> = InOutPatcher<Void, T?>
public typealias Dispatcher<I, T> = (I?) throws -> T

public protocol Aspectable {
    associatedtype Object
    
    var strategy: AspectStrategy { get }
    func dispatch<I, R>(_ dispatcher: Dispatcher<I, R>, patcher: Patcher<I>) rethrows -> R
}

extension Aspectable {
    public func dispatch<I, R>(_ dispatcher: Dispatcher<I, R>, patcher: Patcher<I>) rethrows -> R {
        return try Aspector._dispatch(self, patcher: patcher, dispatcher: dispatcher)
    }
}

// MARK: - Aspect.

public struct Aspect<T>: Aspectable {
    public typealias Object = T
    
    public let obj: T
    public let strategy: AspectStrategy
    
    public init(_ strategy: AspectStrategy, _ obj: T) {
        self.strategy = strategy
        self.obj = obj
    }
}

public struct MetaAspect<T>: Aspectable {
    public typealias Object = T
    
    public let obj: T.Type
    public let strategy: AspectStrategy
    
    public init(_ strategy: AspectStrategy, _ obj: T.Type) {
        self.strategy = strategy
        self.obj = obj
    }
}

public func aspect<T>(
    _ obj: T,
    strategy: AspectStrategy) -> Aspect<T>
{
    return Aspect<T>(strategy, obj)
}

public func aspect<T>(
    _ obj: T.Type,
    strategy: AspectStrategy) -> MetaAspect<T>
{
    return MetaAspect<T>(strategy, obj)
}

// MARK: - Dispatch.

internal func _dispatch<A, I, Result>(
    _ aspect: A,
    patcher: Patcher<I>,
    dispatcher: Dispatcher<I, Result>) rethrows -> Result where A: Aspectable
{
    switch aspect.strategy {
    case .before:
        let i = try patcher(()); return try dispatcher(i)
    case .after:
        let r = try dispatcher(nil); _ = try patcher(()); return r
    }
}
