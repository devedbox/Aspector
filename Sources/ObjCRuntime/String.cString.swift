//
//  String.cString.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/9/1.
//

extension String {
    public var cString: UnsafePointer<CChar> {
        return withCString { $0 }
    }
    
    public init(
        _ cString: UnsafePointer<CChar>)
    {
        self.init(cString: cString)
    }
}
