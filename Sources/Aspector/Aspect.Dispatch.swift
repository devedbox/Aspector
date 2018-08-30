//
//  Aspect.Dispatch.swift
//  Aspector
//
//  Created by devedbox on 2018/8/28.
//

import Foundation

public func dispatch<R>(
    _ func: () throws -> R) rethrows -> R
{
    return try `func`()
}

public func dispatch<T, R>(
    _ func: (T) throws -> R,
    _ arg: T) rethrows -> R
{
    return try `func`(
        arg
    )
}

public func dispatch<T0, T1, R>(
    _ func: (T0, T1) throws -> R,
    _ arg0: T0,
    _ arg1: T1) rethrows -> R
{
    return try `func`(
        arg0,
        arg1
    )
}

public func dispatch<T0, T1, T2, R>(
    _ func: (T0, T1, T2) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2
    )
}

public func dispatch<T0, T1, T2, T3, R>(
    _ func: (T0, T1, T2, T3) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3
    )
}

public func dispatch<T0, T1, T2, T3, T4, R>(
    _ func: (T0, T1, T2, T3, T4) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, R>(
    _ func: (T0, T1, T2, T3, T4, T5) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, T8, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7, T8) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7,
    _ arg8: T8) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7,
    _ arg8: T8,
    _ arg9: T9) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8,
        arg9
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7,
    _ arg8: T8,
    _ arg9: T9,
    _ arg10: T10) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8,
        arg9,
        arg10
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7,
    _ arg8: T8,
    _ arg9: T9,
    _ arg10: T10,
    _ arg11: T11) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8,
        arg9,
        arg10,
        arg11
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7,
    _ arg8: T8,
    _ arg9: T9,
    _ arg10: T10,
    _ arg11: T11,
    _ arg12: T12) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8,
        arg9,
        arg10,
        arg11,
        arg12
    )
}

public func dispatch<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, R>(
    _ func: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) throws -> R,
    _ arg0: T0,
    _ arg1: T1,
    _ arg2: T2,
    _ arg3: T3,
    _ arg4: T4,
    _ arg5: T5,
    _ arg6: T6,
    _ arg7: T7,
    _ arg8: T8,
    _ arg9: T9,
    _ arg10: T10,
    _ arg11: T11,
    _ arg12: T12,
    _ arg13: T13) rethrows -> R
{
    return try `func`(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8,
        arg9,
        arg10,
        arg11,
        arg12,
        arg13
    )
}
