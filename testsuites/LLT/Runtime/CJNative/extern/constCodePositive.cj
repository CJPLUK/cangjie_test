// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// 'const' code may hold, pass and return Extern<T> values: only implicit conversions to Extern<T> and dynamic
// operations on Extern<T> are rejected. Outside 'const' code, 'const' functions may be called with converted values.

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
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

const func id<T>(x: T): T {
    x
}

const constant = id(1)

const func isExtern(a: Any): Bool {
    a is Extern<DummyRT>
}

const func pass(e: Extern<DummyRT>): Extern<DummyRT> {
    let x = e
    id(x)
}

const func passGeneric<T>(e: Extern<T>): Extern<T> where T <: ForeignRuntime<T> {
    e
}

const func orElse(o: ?Extern<DummyRT>, e: Extern<DummyRT>): Extern<DummyRT> {
    o ?? e
}

const func pick(b: Bool, e1: Extern<DummyRT>, e2: Extern<DummyRT>): Extern<DummyRT> {
    if (b) {
        pass(e1)
    } else {
        e2
    }
}

const func pair(e: Extern<DummyRT>): (Extern<DummyRT>, Int64) {
    (e, 1)
}

const func lambdaParameter(): Int64 {
    let l = { x: Extern<DummyRT> => 1 }
    0
}

const none: ?Extern<DummyRT> = None

struct WithConstInit {
    static const count: Int64 = 3
    let e: Extern<DummyRT>
    const init(e: Extern<DummyRT>) {
        this.e = e
    }
}

func payload(e: Extern<DummyRT>): Int64 {
    (Extern<DummyRT>.getPayload(e) as Int64).getOrThrow()
}

main() {
    let e: Extern<DummyRT> = 7
    let h = WithConstInit(pass(8))
    if (payload(id(e)) != 7 || payload(passGeneric(e)) != 7 || payload(orElse(None, e)) != 7 || payload(h.e) != 8 || payload(pick(false, 1, 2)) != 2 || payload(pair(e)[0]) != 7 ||
        constant != 1 || WithConstInit.count != 3 || !isExtern(e) || isExtern(1) || lambdaParameter() != 0 ||
        none.isSome()) {
        throw Exception("unexpected values")
    }
    0
}
