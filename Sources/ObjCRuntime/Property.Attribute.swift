//
//  Property.Attribute.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

extension Property {
    public struct Attribute {
        internal let _objc_property_attribute_t: objc_property_attribute_t
        
        internal init(
            _objc_property_attribute_t: objc_property_attribute_t)
        {
            self._objc_property_attribute_t = _objc_property_attribute_t
        }
    }
}
