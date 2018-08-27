//
//  Class.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Class {
    private let _class: AnyClass
}

extension Class {
    public var version: Int32 {
        return class_getVersion(
            _class
        )
    }
    
    public func set(version: Int32) {
        class_setVersion(
            _class,
            version
        )
    }
}

extension Class {
    public var name: String {
        return String(
            cString: class_getName(
                _class
            )
        )
    }
    
    public var superClass: Class? {
        return class_getSuperclass(_class).map {
            Class(
                _class: $0
            )
        }
    }
    
    public var isMetaClass: Bool {
        return class_isMetaClass(
            _class
        )
    }
    
    public var instanceSize: Int {
        return class_getInstanceSize(
            _class
        )
    }
}

extension Class {
    public func instanceVariable(
        of name: String) -> Ivar?
    {
        return class_getInstanceVariable(
            _class,
            name.withCString {
                $0
            }
        ).map {
            Ivar(_ivar: $0)
        }
    }
    
    public func classVariable(
        of name: String) -> Ivar?
    {
        return class_getClassVariable(
            _class,
            name.withCString {
                $0
            }
        ).map {
            Ivar(
                _ivar: $0
            )
        }
    }
    
    public func addIvar(
        _ name: String,
        size: Int,
        alignment: UInt8,
        types:  UnsafePointer<Int8>?) -> Bool
    {
        return class_addIvar(
            _class,
            name.withCString {
                $0
            },
            size,
            alignment,
            types
        )
    }
    
    public var ivars: [Ivar] {
        var count: UInt32 = 0
        let ivarList = class_copyIvarList(
            _class,
            &count
        )
        
        return (0..<count).map {
            ivarList?.advanced(
                by: Int(
                    $0
                )
            ).pointee
        }.compactMap {
            $0.map {
                Ivar(
                    _ivar: $0
                )
            }
        }
    }
    
    public var ivarLayout: UnsafePointer<UInt8>? {
        return class_getIvarLayout(
            _class
        )
    }
    
    public func set(
        ivarLayout layout: UnsafePointer<UInt8>?)
    {
        class_setIvarLayout(
            _class,
            layout
        )
    }
    
    public var weakIvarLayout: UnsafePointer<UInt8>? {
        return class_getWeakIvarLayout(
            _class
        )
    }
    
    public func set(
        weakIvarLayout layout: UnsafePointer<UInt8>?)
    {
        class_setWeakIvarLayout(
            _class,
            layout
        )
    }
}

extension Class {
    public func property(
        of name: String) -> Property?
    {
        return class_getProperty(
            _class,
            name.withCString {
                $0
            }
        ).map {
            Property(
                _objc_property_t: $0
            )
        }
    }
    
    public var properties: [Property] {
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(
            _class,
            &count
        )
        
        return (0..<count).map {
            propertyList?.advanced(
                by: Int(
                    $0
                )
            ).pointee
        }.compactMap {
            $0.map {
                Property(
                    _objc_property_t: $0
                )
            }
        }
    }
    
    public func add(
        property name: String,
        attributes: [Property.Attribute]) -> Bool
    {
        return class_addProperty(
            _class,
            name.withCString {
                $0
            },
            UnsafePointer<objc_property_attribute_t>(
                attributes.map {
                    $0._attribute
                }
            ),
            UInt32(
                attributes.count
            )
        )
    }
    
    public func replace(
        property name: String,
        attributes: [Property.Attribute])
    {
        class_replaceProperty(
            _class,
            name.withCString {
                $0
            },
            UnsafePointer<objc_property_attribute_t>(
                attributes.map {
                    $0._attribute
                }
            ),
            UInt32(
                attributes.count
            )
        )
    }
}

extension Class {
    public func add(
        method: Method) -> Bool
    {
        return class_addMethod(
            _class,
            method.name._sel,
            method.imp,
            method.types
        )
    }
    
    public func instanceMethod(
        of name: Selector) -> Method?
    {
        return class_getInstanceMethod(
            _class,
            name._sel
        ).map {
            Method(
                _method: $0
            )
        }
    }
    
    public func classMethod(
        of name: Selector) -> Method?
    {
        return class_getClassMethod(
            _class,
            name._sel
        ).map {
            Method(
                _method: $0
            )
        }
    }
    
    public var methods: [Method] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(
            _class,
            &count
        )
        
        return (0..<count).map {
            methodList?.advanced(
                by: Int(
                    $0
                )
            ).pointee
        }.compactMap {
            $0.map {
                Method(
                    _method: $0
                )
            }
        }
    }
    
    public func replace(
        method name: Selector,
        with method: Method) -> IMP?
    {
        return class_replaceMethod(
            _class,
            name._sel,
            method.imp,
            method.types
        )
    }
    
    public func methodImp(
        of name: Selector) -> IMP?
    {
        return class_getMethodImplementation(
            _class,
            name._sel
        )
    }
    
    public func methodImpStret(
        of name: Selector) -> IMP?
    {
        return class_getMethodImplementation_stret(
            _class,
            name._sel
        )
    }
    
    public func responds(
        to selector: Selector) -> Bool
    {
        return class_respondsToMethod(
            _class,
            selector._sel
        )
    }
}

extension Class {
    public func add(
        protocol: Protocol) -> Bool
    {
        return class_addProtocol(
            _class,
            `protocol`
        )
    }
    
    public func conforms(
        to protocol: Protocol) -> Bool
    {
        return class_conformsToProtocol(
            _class,
            `protocol`
        )
    }
    
    public var protocols: [Protocol] {
        var count: UInt32 = 0
        let protocolList = class_copyProtocolList(
            _class,
            &count
        )
        return (0..<count).compactMap {
            protocolList?[
                Int($0)
            ]
        }
    }
}


