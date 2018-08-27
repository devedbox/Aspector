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
    
    public var attributeValues: String? {
        return property_getAttributes(
            _property
        ).map {
            String(
                cString: $0
            )
        }
    }
    
    public func attributeValue(of name: String) -> String? {
        return property_copyAttributeValue(
            _property,
            name.withCString {
                $0
            }
        ).map {
            String(
                cString: $0
            )
        }
    }
    
    public var attributes: [Attribute] {
        var count: UInt32 = 0
        let attrLists = property_copyAttributeList(
            _property,
            &count
        )
        
        return (0..<count).map {
            attrLists?.advanced(
                by: Int(
                    $0
                )
            ).pointee
        }.compactMap {
            $0.map {
                Attribute(
                    _attribute: $0
                )
            }
        }
    }
}
