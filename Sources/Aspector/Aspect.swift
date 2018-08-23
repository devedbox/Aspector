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

public typealias Patcher = () -> Void
public typealias Dispatcher<T> = () -> T

public protocol Aspectable {
    associatedtype Object
    
    var strategy: AspectStrategy { get }
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

public func aspect<T>(_ obj: T, strategy: AspectStrategy) -> Aspect<T> {
    return Aspect<T>(strategy, obj)
}

public func aspect<T>(_ obj: T.Type, strategy: AspectStrategy) -> MetaAspect<T> {
    return MetaAspect<T>(strategy, obj)
}

// MARK: - Dispatch.

internal func dispatch<A, Result>(_ aspect: A, patcher: Patcher, dispatcher: () -> Result) -> Result where A: Aspectable {
    switch aspect.strategy {
    case .before:
        patcher(); return dispatcher()
    case .after:
        let r = dispatcher(); patcher(); return r
    }
}
