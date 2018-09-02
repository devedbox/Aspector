//
//  Method.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Method {
    
    public struct Description {
        public let name: Selector?
        public let typeEncoding: String?
    }
    
    private let _method: ObjectiveC.Method
    
    internal init(
        _method: ObjectiveC.Method)
    {
        self._method = _method
    }
}

extension Method {
    public var name: Selector {
        return Selector(
            _sel: method_getName(
                _method
            )
        )
    }
    
    public var imp: IMP {
        return IMP(
            _imp: method_getImplementation(
                _method
            )
        )
    }
    
    public func set(
        imp: IMP) -> IMP
    {
        return IMP(
            _imp: method_setImplementation(
                _method,
                imp._imp
            )
        )
    }
    
    public var types: UnsafePointer<Int8>? {
        return method_getTypeEncoding(
            _method
        )
    }
    
    public static func exchange(
        _ method1: Method,
        another: Method)
    {
        method_exchangeImplementations(
            method1._method,
            method1._method
        )
    }
}

extension Method {
    public var returnType: String {
        return String(
            method_copyReturnType(
                _method
            )
        )
    }
    
    public var countOfArguments: UInt32 {
        return method_getNumberOfArguments(
            _method
        )
    }
    
    public func typeOfArgument(
        at index: UInt32) -> String
    {
        let buffer = UnsafeMutablePointer<Int8>.allocate(
            capacity: 512
        )
        method_getArgumentType(
            _method,
            index,
            buffer,
            512
        )
        return String(
            buffer
        )
    }
}

extension Method {
    public var description: Description {
        return Optional.some(
            method_getDescription(
                _method
            ).pointee
        ).map {
            Description(
                name: $0.name.map {
                    Selector(
                        _sel: $0
                    )
                },
                typeEncoding: $0.types.map {
                    String(
                        $0
                    )
                }
            )
        }!
    }
}
