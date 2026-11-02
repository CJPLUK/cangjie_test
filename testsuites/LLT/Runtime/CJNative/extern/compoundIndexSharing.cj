// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// c[i] op= v, c[i]++ and c[i]-- evaluate the index i once, also when it is a dynamic operation, or when it is
// implicitly converted to Extern<T>. The getter and the setter share the value of i before any conversion, and each
// converts it where it expects Extern<T>.

var indexCalls = 0
var conversions = 0
var reads = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> {
        reads++
        Extern<RT>(0)
    }

    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<U>(e: Extern<RT>): U {
        (Extern<RT>.getPayload(e) as U).getOrThrow()
    }

    public static func toExtern<U>(value: U): Extern<RT> {
        conversions++
        Extern<RT>(value)
    }
}

func idx(a: Any): Int64 {
    match (a) {
        case e: Extern<RT> => RT.fromExtern<Int64>(e)
        case _ => (a as Int64).getOrThrow()
    }
}

class Both {
    let values = [10, 20]
    operator func [](index: Extern<RT>): Int64 {
        values[idx(index)]
    }
    operator func [](index: Extern<RT>, value!: Int64): Unit {
        values[idx(index)] = value
    }
}

class GetterExtern {
    let values = [10, 20]
    operator func [](index: Extern<RT>): Int64 {
        values[idx(index)]
    }
    operator func [](index: Int64, value!: Int64): Unit {
        values[index] = value
    }
}

class SetterExtern {
    let values = [10, 20]
    operator func [](index: Int64): Int64 {
        values[index]
    }
    operator func [](index: Extern<RT>, value!: Int64): Unit {
        values[idx(index)] = value
    }
}

class AnyIndex {
    let values = [10, 20]
    operator func [](index: Any): Int64 {
        values[idx(index)]
    }
    operator func [](index: Any, value!: Int64): Unit {
        values[idx(index)] = value
    }
}

func next(): Int64 {
    indexCalls++
    indexCalls - 1
}

func reset(): Unit {
    indexCalls = 0
    conversions = 0
    reads = 0
}

func check(name: String, ok: Bool): Unit {
    if (!ok) {
        throw Exception("${name}: indexCalls=${indexCalls}, conversions=${conversions}, reads=${reads}")
    }
}

main() {
    let b = Both()
    reset()
    b[next()] += 1
    check("both +=", indexCalls == 1 && conversions == 2 && b.values == [11, 20])
    reset()
    b[next()]++
    check("both ++", indexCalls == 1 && conversions == 2 && b.values == [12, 20])
    reset()
    b[next()]--
    check("both --", indexCalls == 1 && conversions == 2 && b.values == [11, 20])
    reset()
    // The branches of the if are converted, so the if has type Extern<RT> and is shared after the conversion.
    b[if (indexCalls >= 0) { next() } else { 0 }] += 1
    check("both if", indexCalls == 1 && conversions == 1 && b.values == [12, 20])
    // An explicit conversion is part of the shared index.
    reset()
    b[RT.toExtern(next())] += 1
    check("both explicit", indexCalls == 1 && conversions == 1 && b.values == [13, 20])

    let g = GetterExtern()
    reset()
    g[next()] += 1
    check("getter", indexCalls == 1 && conversions == 1 && g.values == [11, 20])

    let s = SetterExtern()
    reset()
    s[next()] += 1
    check("setter", indexCalls == 1 && conversions == 1 && s.values == [11, 20])

    let a = AnyIndex()
    let e = Extern<RT>(())
    reset()
    a[e.next] += 1
    check("dynamic +=", reads == 1 && a.values == [11, 20])
    reset()
    a[e.next]++
    check("dynamic ++", reads == 1 && a.values == [12, 20])
    0
}
