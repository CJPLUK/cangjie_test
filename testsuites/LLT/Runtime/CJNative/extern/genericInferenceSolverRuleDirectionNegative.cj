// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 expected 'Struct-Array<Struct-Extern<Class-RT>>', found 'Struct-Array<Int64>'
// ASSERT: scan-4 unable to infer generic argument of this function
// ASSERT: scan-1 of type 'Struct-Extern<Class-RT>', impossible to match parameter type 'Int64'
// ASSERT: scan-1 of type 'Struct-Array<Struct-Extern<Class-RT>>', impossible to match parameter type 'Struct-Array<Int64>'
// ASSERT: scan-1 of type 'Class-Box<Struct-Extern<Class-RT>>', impossible to match parameter type 'Class-Box<Int64>'
// ASSERT: scan-1 of type '() -> Struct-Extern<Class-RT>', impossible to match parameter type '() -> Int64'
// ASSERT: scan-1 5 errors generated
// ASSERT: scan-not Assertion

// A value is only converted to Extern<T>, never from it. When the type arguments of a generic call are inferred,
// only the parts Extern<T> of a parameter type accept the corresponding parts of the argument type, so a call with
// an Extern<T> value where another type is expected is rejected as with any other mismatched argument.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

class Box<T> {
    Box(let value: T) {}
}

func plain<X>(x: X, n: Int64): X { x }
func arrayOf<X>(a: Array<Extern<RT>>, x: X): X { x }
func intArray<X>(a: Array<Int64>, x: X): X { x }
func boxOf<X>(b: Box<Int64>, x: X): X { x }
func result<X>(p: () -> Int64, x: X): X { x }

main() {
    let e = Extern<RT>(0)
    let ints = [1]
    let externs = [e]
    let box = Box(e)
    plain(1, e)                 // An Extern<T> value is not converted to another type.
    arrayOf(ints, 1)            // An existing array is not converted to an array of Extern<T>.
    intArray(externs, 1)        // Nor is an array of Extern<T> converted to another array.
    boxOf(box, 1)               // Nor an instance of a generic class.
    result({ => e }, 1)         // Nor the result of a function.
    0
}
