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
            _objc_property_attribute_t: objc_property_attribute_t)
        {
            self._attribute = _objc_property_attribute_t
        }
        
        public init(
            name: String,
            value: String)
        {
            _attribute = objc_property_attribute_t(
                name: name.withCString {
                    $0
                },
                value: value.withCString {
                    $0
                }
            )
        }
    }
}
