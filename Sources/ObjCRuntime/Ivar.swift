//
//  Ivar.swift
//  ObjCRuntime
//
//  Created by devedbox on 2018/8/26.
//

import ObjectiveC

public struct Ivar {
    private let _ivar: ObjectiveC.Ivar
    
    internal init(
        _ivar: ObjectiveC.Ivar)
    {
        self._ivar = _ivar
    }
}
