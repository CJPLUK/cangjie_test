// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// 'const' code may hold Extern<T> values in blocks ending with a declaration, in pipelines, which are desugared into
// calls, in 'match' expressions without a selector and in 'else if' chains, as long as no value is implicitly
// converted to Extern<T>.

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern<DummyRT>.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

const func id<T>(x: T): T {
    x
}

const func endsWithDeclaration(e: Extern<DummyRT>): Unit {
    let _ = e
}

const func piped(e: Extern<DummyRT>): Extern<DummyRT> {
    e |> id
}

const func pipedInt(n: Int64): Int64 {
    n |> id
}

const func noSelector(b: Bool, e1: Extern<DummyRT>, e2: Extern<DummyRT>): Extern<DummyRT> {
    match {
        case b => e1
        case _ => e2
    }
}

const func elseIf(n: Int64, e1: Extern<DummyRT>, e2: Extern<DummyRT>, e3: Extern<DummyRT>): Extern<DummyRT> {
    if (n < 0) {
        e1
    } else if (n == 0) {
        e2
    } else {
        e3
    }
}

func payload(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func check(name: String, ok: Bool): Unit {
    if (!ok) {
        throw Exception(name)
    }
}

main() {
    let e1: Extern<DummyRT> = 1
    let e2: Extern<DummyRT> = 2
    let e3: Extern<DummyRT> = 3
    endsWithDeclaration(e1)
    check("pipeline", payload(piped(e1)) == 1 && pipedInt(4) == 4)
    check("match without selector", payload(noSelector(true, e1, e2)) == 1 && payload(noSelector(false, e1, e2)) == 2)
    check("else if", payload(elseIf(-1, e1, e2, e3)) == 1 && payload(elseIf(0, e1, e2, e3)) == 2 &&
        payload(elseIf(1, e1, e2, e3)) == 3)
    0
}
