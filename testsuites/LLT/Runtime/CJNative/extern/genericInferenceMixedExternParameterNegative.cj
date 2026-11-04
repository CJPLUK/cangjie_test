// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-2 unable to infer generic argument of this function
// ASSERT: scan of type 'Tuple<Int64, Struct-String>', should match parameter type 'Tuple<Int64, Generics-T>'
// ASSERT: scan expected 'Tuple<Struct-Extern<Class-RT>, Int64>', found 'Tuple<Int64, Int64>'
// ASSERT: scan expected 'Struct-Array<Tuple<Int64, Struct-Extern<Class-RT>>>', found 'Struct-Array<Tuple<Int64, Int64>>'
// ASSERT: scan expected '() -> Tuple<Struct-Extern<Class-RT>, Int64>', found '() -> Tuple<Int64, Int64>'
// ASSERT: scan-not Assertion

// In a parameter type mixing Extern<T> and type variables, only the parts of a literal or a lambda matching Extern<T>
// are converted. Its other parts must agree with the type arguments, and existing values are not converted.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

func pairWith<T>(value: T, pair: (Extern<RT>, T)): Unit {}

func pairs<T>(values: Array<(T, Extern<RT>)>, n: Int64): Unit {}

func callResult<T>(f: () -> (Extern<RT>, T)): Unit {}

func sizeOf<R>(values: Array<Extern<R>>): Unit where R <: ForeignRuntime<R> {}

func plain(): (Int64, Int64) {
    (1, 2)
}

main() {
    let tuple = (1, 2)
    let array = [(1, 2)]
    pairWith(0, (1, "s"))       // T cannot be both Int64 and String.
    pairWith(0, tuple)          // An existing tuple is not converted.
    pairs(array, 0)             // An existing array is not converted.
    callResult(plain)           // An existing function is not converted.
    sizeOf([1, 2])              // No argument of type Extern<T> determines R.
    0
}
