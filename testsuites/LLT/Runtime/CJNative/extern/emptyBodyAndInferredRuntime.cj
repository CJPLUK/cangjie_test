// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// A function or lambda whose body is empty, or ends with a declaration, has the unit value. That value is converted
// when the return type is Extern<T>. A lambda whose expected return type is Extern<R>, with R still to be inferred,
// keeps a body of type Extern<T>, and that body determines R.

var units = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }

    public static func fromExtern<R>(e: Extern<RT>): R {
        (Extern<RT>.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(value: R): Extern<RT> {
        if (value is Unit) {
            units++
        }
        Extern<RT>(value)
    }
}

func empty(): Extern<RT> {}

func produce<R>(f: () -> Extern<R>): Extern<R> where R <: ForeignRuntime<R> {
    f()
}

func check(name: String, ok: Bool): Unit {
    if (!ok) {
        throw Exception(name)
    }
}

main() {
    RT.fromExtern<Unit>(empty())
    let endsWithDecl: () -> Extern<RT> = { => let _ = 1 }
    RT.fromExtern<Unit>(endsWithDecl())
    let emptyLambda: () -> Extern<RT> = { => }
    RT.fromExtern<Unit>(emptyLambda())
    check("unit bodies", units == 3)

    let known = RT.toExtern(4)
    units = 0
    let fromValue = produce({ => known })
    check("Extern lambda determines the runtime", units == 0 && RT.fromExtern<Int64>(fromValue) == 4)

    let fromLiteral = produce<RT>({ => 5 })
    check("explicit runtime converts the lambda body", RT.fromExtern<Int64>(fromLiteral) == 5)
    0
}
