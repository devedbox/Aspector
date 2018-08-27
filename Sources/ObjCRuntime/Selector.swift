//
//  Selector.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/27.
//

import ObjectiveC

public struct Selector {
    internal let _sel: ObjectiveC.Selector
}

extension Selector {
    public var name: String {
        return String(
            cString: sel_getName(
                _sel
            )
        )
    }
    
    public static func register(
        _ name: String) -> Selector
    {
        return Selector(
            _sel: sel_registerName(
                name.withCString {
                    $0
                }
            )
        )
    }
    
    public static func getUid(
        _ name: String) -> Selector
    {
        return Selector(
            _sel: sel_getUid(
                name.withCString {
                    $0
                }
            )
        )
    }
}

extension Selector: Equatable {
    public static func == (
        lhs: Selector,
        rhs: Selector) -> Bool
    {
        return sel_isEqual(
            lhs._sel,
            rhs._sel
        )
    }
}
