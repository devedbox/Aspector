//
//  Protocol.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/30.
//

import Foundation
import ObjectiveC

public final class ObjCProtocol {
    internal let _protocol: Protocol
    
    internal init(_protocol: Protocol) {
        self._protocol = _protocol
    }
    
    public convenience init?(name: String) {
        guard let proto = objc_getProtocol(name.withCString { $0 }) else {
            return nil
        }
        
        self.init(_protocol: proto)
    }
}
