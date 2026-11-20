// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-3 unable to infer generic argument of this function
// ASSERT: scan of type 'Struct-Extern<Class-RT2>', should match parameter type 'Struct-Extern<Generics-R>'
// ASSERT: scan-not Assertion

// The runtime R of a parameter of type Extern<R> is not inferred from an argument that needs a conversion, so a call
// where no argument of type Extern<T> determines R is a type error. Arguments of type Extern<T> still constrain R, so
// values of different runtimes are not mixed.

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

func forward<R>(e: Extern<R>, value: Extern<R>): Extern<R> where R <: ForeignRuntime<R> {
    value
}

func wrap<R>(value: Extern<R>): Extern<R> where R <: ForeignRuntime<R> {
    value
}

main() {
    let e = Extern<RT>(0)
    let e2 = Extern<RT2>(0)
    forward(1, 2)       // No argument of type Extern<T> determines R.
    wrap(3)             // No argument of type Extern<T> determines R.
    forward(e, e2)      // R cannot be both RT and RT2.
    0
}
