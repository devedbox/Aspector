//
//  Ivar.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Ivar {
    internal let _ivar: ObjectiveC.Ivar
    
    internal init(
        _ivar: ObjectiveC.Ivar)
    {
        self._ivar = _ivar
    }
}

extension Ivar {
    public var name: String? {
        return ivar_getName(_ivar).map {
            String(
                $0
            )
        }
    }
    
    public var types: String? {
        return ivar_getTypeEncoding(_ivar).map {
            String(
                $0
            )
        }
    }
    
    public var offset: Int {
        return ivar_getOffset(
            _ivar
        )
    }
}
