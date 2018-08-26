//
//  Property.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Property {
    internal let _objc_property_t: objc_property_t
    
    internal init(
        _objc_property_t: objc_property_t)
    {
        self._objc_property_t = _objc_property_t
    }
}
