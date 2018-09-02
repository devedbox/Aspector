//
//  Property.Attribute.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

extension Property {
    public struct Attribute {
        internal let _attribute: objc_property_attribute_t
        
        internal init(
            _attribute: objc_property_attribute_t)
        {
            self._attribute = _attribute
        }
        
        public init(
            name: String,
            value: String)
        {
            _attribute = objc_property_attribute_t(
                name: name.cString,
                value: value.cString
            )
        }
    }
}
