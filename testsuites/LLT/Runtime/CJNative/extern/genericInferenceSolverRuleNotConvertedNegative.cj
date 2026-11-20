// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-7 error: mismatched types
// ASSERT: scan-1 parameters and arguments mismatch
// ASSERT: scan-3 unable to infer generic argument of this function
// ASSERT: scan-1 of type 'Struct-Array<Tuple<Struct-String, Int64>>', impossible to match parameter type 'Struct-Array<Tuple<Generics-T, Struct-Extern<Class-RT>>>'
// ASSERT: scan-1 of type '(Int64) -> Struct-String @ideal', impossible to match parameter type '(Struct-Extern<Class-RT>) -> Generics-T'
// ASSERT: scan-1 of type 'Class-Derived<Tuple<Int64, Struct-String>>', impossible to match parameter type 'Class-Base<Tuple<Struct-Extern<Class-RT>, Generics-T>>'
// ASSERT: scan-not Assertion

// Only values of literals and lambdas are converted to the parts Extern<T> of a parameter type. Existing values of
// other types are not converted. Where the type arguments are inferred and the conversion would be inside the type
// argument of a generic type or a parameter of a function type, as with Option boxing, they are not inferred.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

class RT2 <: ForeignRuntime<RT2> {
    public static func memberAccess(e: Extern<RT2>, name: String): Extern<RT2> { throw Exception() }
    public static func indexedAccess(e: Extern<RT2>, index: Any): Extern<RT2> { throw Exception() }
    public static func memberUpdate(e: Extern<RT2>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT2>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT2>, args: Array<Any>): Extern<RT2> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT2>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT2> { Extern<RT2>(value) }
}

class Box<T> {
    Box(let value: T) {}
}

open class Base<T> {}

class Derived<T> <: Base<T> {
    init(x: T) {}
}

func arrayOf<T>(p: Array<Extern<RT>>, x: T): T { x }
func tupleOf<T>(p: (Extern<RT>, Int64), x: T): T { x }
func resultOf<T>(p: () -> Extern<RT>, x: T): T { x }
func boxOf<T>(p: Box<Extern<RT>>, x: T): T { x }
func taking<T>(p: (Extern<RT>) -> Int64, x: T): T { x }
func second<T>(p: (Extern<RT>, T)): T { p[1] }
func firstOfPairs<T>(p: Array<(T, Extern<RT>)>): T { p[0][0] }
func callWithExtern<T>(p: (Extern<RT>) -> T): T { p(Extern<RT>(0)) }
func base<T>(p: Base<(Extern<RT>, T)>): Int64 { 1 }
func one(): Int64 { 1 }

main() {
    let ints = [1]
    let externs2 = [Extern<RT2>(0)]
    let tuple = (1, 2)
    let box = Box(1)
    let pairs = [("a", 1)]
    let derived = Derived((1, "s"))
    arrayOf(ints, 2)                        // An existing array is not converted.
    arrayOf(externs2, 2)                    // Nor an existing array of another runtime.
    tupleOf(tuple, 3)                       // Nor an existing tuple.
    resultOf(one, 3)                        // Nor a function.
    boxOf(box, 3)                           // Nor an instance of a generic class.
    taking({ y: Int64 => y }, 3)            // A lambda parameter of another type is not converted.
    second(tuple)                           // An existing tuple is not converted where T is inferred.
    firstOfPairs(pairs)                     // Nor an existing array.
    callWithExtern({ y: Int64 => "s" })     // Nor a lambda parameter.
    base(derived)                           // Nor an instance of a subclass.
    0
}
