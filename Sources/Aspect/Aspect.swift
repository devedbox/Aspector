//
// Aspect.swift
// Aspect
//
// Created by devedbox.
//

import Foundation
import UIKit

public struct Aspect<T> {
    public enum Strategy {
        case before
        case after
    }
    
    public let obj: T
    public let exe: () -> Void
    public let strategy: Strategy
    
    public init(_ strategy: Strategy, _ obj: T, exe: @escaping () -> Void) {
        self.strategy = strategy
        self.obj = obj
        self.exe = exe
    }
}
