// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// In c[i] op= v, c[i]++ and c[i]--, an index that is an if, a try, a match, a block or a parenthesized expression is
// evaluated once and shared before any conversion, like any other index. Each operator that takes Extern<T> converts
// the whole shared value, whichever of the getter and the setter it is.

var indexCalls = 0
var conversions = 0

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
        conversions++
        Extern<RT>(value)
    }
}

class GetterExtern {
    let values = [10, 20]
    operator func [](index: Extern<RT>): Int64 {
        values[RT.fromExtern<Int64>(index)]
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
        values[RT.fromExtern<Int64>(index)] = value
    }
}

class Both {
    let values = [10, 20]
    operator func [](index: Extern<RT>): Int64 {
        values[RT.fromExtern<Int64>(index)]
    }
    operator func [](index: Extern<RT>, value!: Int64): Unit {
        values[RT.fromExtern<Int64>(index)] = value
    }
}

func one(): Int64 {
    indexCalls++
    1
}

func check(name: String, ok: Bool, expectedConversions: Int64): Unit {
    if (!ok || indexCalls != 1 || conversions != expectedConversions) {
        throw Exception("${name}: indexCalls=${indexCalls}, conversions=${conversions}")
    }
    indexCalls = 0
    conversions = 0
}

main() {
    let flag = indexCalls == 0
    let g = GetterExtern()
    g[if (flag) { one() } else { 0 }] += 1
    check("getter if", g.values == [10, 21], 1)
    g[try { one() } catch (_: Exception) { 0 }] += 1
    check("getter try", g.values == [10, 22], 1)
    g[match (flag) {
        case true => one()
        case false => 0
    }] += 1
    check("getter match", g.values == [10, 23], 1)
    g[(one())] += 1
    check("getter paren", g.values == [10, 24], 1)
    g[unsafe { one() }] += 1
    check("getter block", g.values == [10, 25], 1)
    g[(unsafe { one() })] += 1
    check("getter paren block", g.values == [10, 26], 1)
    g[if (flag) { one() } else { 0 }]++
    check("getter ++", g.values == [10, 27], 1)

    let s = SetterExtern()
    s[if (flag) { one() } else { 0 }] += 1
    check("setter if", s.values == [10, 21], 1)
    s[try { one() } catch (_: Exception) { 0 }] += 1
    check("setter try", s.values == [10, 22], 1)
    s[if (flag) { one() } else { 0 }]--
    check("setter --", s.values == [10, 21], 1)

    let b = Both()
    b[if (flag) { one() } else { 0 }] += 1
    check("both if", b.values == [10, 21], 2)
    b[(one())] += 1
    check("both paren", b.values == [10, 22], 2)
    b[unsafe { one() }] += 1
    check("both block", b.values == [10, 23], 2)
    0
}
