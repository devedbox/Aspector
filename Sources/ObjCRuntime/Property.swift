//
//  Property.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Property {
    internal let _property: objc_property_t
    
    internal init(
        _objc_property_t: objc_property_t)
    {
        self._property = _objc_property_t
    }
}

extension Property {
    public var name: String {
        return String(
            cString: property_getName(
                _property
            )
        )
    }
    
    public var attributes: String? {
        return property_getAttributes(
            _property
        ).map {
            String(
                cString: $0
            )
        }
    }
}
