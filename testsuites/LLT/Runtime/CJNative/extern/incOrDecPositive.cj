// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// ++ and -- of an integer operand are unaffected by values of type Extern<T> around it: in its base, in its indices or
// next to it in the same object. A dynamic member or index of a value of type Extern<T> is incremented with +=.

var updates = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit { updates++ }
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit { updates++ }
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        Extern<RT>(fromExtern<Int64>(e) + (args[0] as Int64).getOrThrow())
    }

    public static func fromExtern<R>(e: Extern<RT>): R {
        (Extern<RT>.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(value: R): Extern<RT> {
        Extern<RT>(value)
    }
}

class Holder {
    var field: Extern<RT> = Extern<RT>(1)
    var count = 0
}

func check(name: String, ok: Bool): Unit {
    if (!ok) {
        throw Exception(name)
    }
}

main() {
    let e = Extern<RT>(1)
    let holder = Holder()
    var counts = [0, 0]
    counts[RT.fromExtern<Int64>(e)]++
    check("index from Extern", counts == [0, 1])
    counts[RT.fromExtern<Int64>(e.f)]--
    check("index from dynamic member", counts == [0, 0])
    holder.count++
    holder.count++
    holder.count--
    check("field next to Extern field", holder.count == 1 && RT.fromExtern<Int64>(holder.field) == 1)
    e.f += 1
    e[0] += 1
    check("compound assignment of dynamic accesses", updates == 2)
    0
}
