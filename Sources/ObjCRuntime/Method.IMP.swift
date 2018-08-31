//
//  Method.IMP.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/31.
//

import ObjectiveC

extension Method {
    public final class IMP {
        internal let _imp: ObjectiveC.IMP
        
        internal init(_imp: ObjectiveC.IMP) {
            self._imp = _imp
        }
    }
}

extension Method.IMP {
    public var `func`: Any? {
        return imp_getBlock(
            _imp
        )
    }
    
    public func removeFunc() -> Bool {
        return imp_removeBlock(
            _imp
        )
    }
}

extension Method.IMP {
    public convenience init?<T, R>(
        func: @escaping (T) -> R) where T: AnyObject, R: AnyObject
    {
        typealias Funcc = @convention(block) (
            AnyObject)
            -> AnyObject
        
        let funcc: Funcc = {
            `func`($0 as! T)
        }
        
        self.init(
            _imp: imp_implementationWithBlock(
                unsafeBitCast(
                    funcc,
                    to: AnyObject.self
                )
            )
        )
    }
    
    public convenience init?<T0, T1, R>(
        func: @escaping (T0, T1) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, R>(
        func: @escaping (T0, T1, T2) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, R>(
        func: @escaping (T0, T1, T2, T3) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, T4, R>(
        func: @escaping (T0, T1, T2, T3, T4) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, T4, T5, R>(
        func: @escaping (T0, T1, T2, T3, T4, T5) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, T4, T5, T6, R>(
        func: @escaping (T0, T1, T2, T3, T4, T5, T6) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, T4, T5, T6, T7, R>(
        func: @escaping (T0, T1, T2, T3, T4, T5, T6, T7) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, T4, T5, T6, T7, T8, R>(
        func: @escaping (T0, T1, T2, T3, T4, T5, T6, T7, T8) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
    
    public convenience init?<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R>(
        func: @escaping (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) -> R)
    {
        typealias Funcc = @convention(block) (
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject,
            AnyObject)
            -> AnyObject
        
        guard let funcc = `func` as? Funcc else {
            return nil
        }
        self.init(
            _imp: imp_implementationWithBlock(
                funcc
            )
        )
    }
}
