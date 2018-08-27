//
//  Object.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/27.
//

import ObjectiveC

public struct Object {
    internal let _obj: Any
}

extension Object {
    public func ivarValue(
        of ivar: Ivar) -> Any?
    {
        return object_getIvar(
            _obj,
            ivar._ivar
        )
    }
    
    public func set(value: Any?, for ivar: Ivar) {
        object_setIvar(
            _obj,
            ivar._ivar,
            value
        )
    }
}

extension Object {
    public var className: String {
        return String(
            cString: object_getClassName(
                _obj
            )
        )
    }
    
    public var `class`: AnyClass {
        return object_getClass(
            _obj
        )!
    }
    
    public func set(class: AnyClass) -> AnyClass {
        return object_setClass(
            _obj,
            `class`
        )!
    }
}
