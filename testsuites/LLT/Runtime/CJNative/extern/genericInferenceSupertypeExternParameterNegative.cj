// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-2 unable to infer generic argument of this function
// ASSERT: scan of type 'Struct-Array<Tuple<Int64, Struct-String>>', should match parameter type 'Interface-Collection<Tuple<Struct-Extern<Class-RT>, Generics-T>>'
// ASSERT: scan expected 'Interface-Collection<Tuple<Struct-Extern<Class-RT>, Int64>>', found 'Struct-Array<Tuple<Int64, Int64>>'
// ASSERT: scan of type 'Tuple<Int64, Struct-String>', should match parameter type 'Enum-Option<Tuple<Struct-Extern<Class-RT>, Generics-T>>'
// ASSERT: scan-not Assertion

// In a parameter type mixing Extern<T> and type variables, a literal whose type is a subtype of it only has the parts
// matching Extern<T> converted. Its other parts must agree with the type arguments, and existing values are not
// converted.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

func pairsWith<T>(value: T, pairs: Collection<(Extern<RT>, T)>): Unit {}

func optional<T>(value: T, pair: ?(Extern<RT>, T)): Unit {}

main() {
    let array = [(1, 2)]
    pairsWith(0, [(1, "s")])    // T cannot be both Int64 and String.
    pairsWith(0, array)         // An existing array is not converted.
    optional(0, (1, "s"))       // T cannot be both Int64 and String.
    0
}
