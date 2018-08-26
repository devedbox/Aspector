//
//  Method.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Method {
    private let _method: ObjectiveC.Method
    
    internal init(
        _method: ObjectiveC.Method)
    {
        self._method = _method
    }
}

extension Method {
    public var name: Selector {
        return method_getName(
            _method
        )
    }
    
    public var imp: IMP {
        return method_getImplementation(
            _method
        )
    }
    
    public var types: UnsafePointer<Int8>? {
        return method_getTypeEncoding(
            _method
        )
    }
}
