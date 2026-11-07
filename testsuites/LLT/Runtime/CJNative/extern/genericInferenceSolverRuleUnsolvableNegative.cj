// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-21 unable to infer generic argument of this function
// ASSERT: scan-not Assertion

// Type arguments are not inferred from conversions to Extern<T>:
// - the parts Extern<T> of a parameter type accept any argument, but the other parts must agree with the type
//   arguments;
// - the runtime R of Extern<R> is only determined by values of type Extern<T>;
// - the bounds of a type variable, its arguments and the return type are matched without conversions.

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

func sizeOf<T>(x: T, p: Collection<(Extern<RT>, T)>): Int64 { p.size }
func optional<T>(x: T, p: ?(Extern<RT>, T)): Int64 { 1 }
func pairWith<T>(x: T, p: (Extern<RT>, T)): Int64 { 1 }

func runtimeOf<R>(p: Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func sameRuntime<R>(a: Extern<R>, b: Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeArray<R>(p: Array<Extern<R>>): Int64 where R <: ForeignRuntime<R> { p.size }
func runtimeTuple<R>(p: (Extern<R>, Int64)): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeResult<R>(p: () -> Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeResults<R>(p: () -> Array<Extern<R>>): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeAndAction<R>(p: Extern<R>, g: () -> Unit): Int64 where R <: ForeignRuntime<R> { 1 }
func valueRuntimeAndAction<T, R>(x: T, p: Extern<R>, g: () -> Unit): Int64 where R <: ForeignRuntime<R> { 1 }

func sizeAndValue<T>(xs: Array<T>, y: T): Int64 { xs.size }
func valueAndSize<T>(y: T, xs: Array<T>): Int64 { xs.size }
func two<T>(x: T, y: T): Int64 { 1 }
func sizes<T>(xs: Array<T>, ys: Array<T>): Int64 { xs.size }

func same<R>(e: Extern<R>): Extern<R> where R <: ForeignRuntime<R> { e }
func wrap<T>(x: T): Array<T> { [x] }
func some<T>(x: T): ?T { x }
func pair<T>(x: T): (T, T) { (x, x) }

main() {
    let e = Extern<RT>(0)
    let e2 = Extern<RT2>(0)
    let externs = [e]
    let ints = [1]
    sizeOf(0, [(1, "s")])                   // T cannot be both Int64 and String.
    optional(0, (1, "s"))                   // T cannot be both Int64 and String.
    pairWith(e, (1, 2))                     // T cannot be both Extern<RT> and Int64.

    runtimeOf(1)                            // No value determines the runtime.
    sameRuntime(e, e2)                      // The runtime cannot be both RT and RT2.
    runtimeArray([1, 2])                    // No value determines the runtime.
    runtimeArray([e, 1])                    // The element type of the array literal is not Extern<RT>.
    runtimeTuple((1, 1))                    // No value determines the runtime.
    runtimeResult({ => 1 })                 // No value determines the runtime.
    runtimeResult { 1 }                     // No value determines the runtime.
    let results = runtimeResults({ => [1] }) // No value determines the runtime.
    runtimeAndAction(1, { => () })          // No value determines the runtime.
    valueRuntimeAndAction(e, 1, { => () })  // No value determines the runtime.

    sizeAndValue(externs, 1)                // T = Extern<RT> does not accept the value 1.
    valueAndSize(1, externs)                // In any order.
    two(e, 1)                               // T cannot be both Extern<RT> and Int64.
    sizes(externs, ints)                    // T cannot be both Extern<RT> and Int64.

    let x: Int64 = same(e)                  // A runtime value is not converted to Int64.
    let a: Array<Extern<RT>> = wrap(1)      // The return type is matched without conversions.
    let o: ?Extern<RT> = some(1)            // The return type is matched without conversions.
    let p: (Extern<RT>, Extern<RT>) = pair(1) // The return type is matched without conversions.
    0
}
