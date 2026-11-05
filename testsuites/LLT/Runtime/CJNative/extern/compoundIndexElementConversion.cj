// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// In c[i] op= v, c[i]++ and c[i]--, an array or tuple literal index whose elements are converted to Extern<T> for both
// the getter and the setter is evaluated once, with each element converted once.

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

class ArrayIndex {
    let values = [10, 20]
    operator func [](index: Array<Extern<RT>>): Int64 {
        values[RT.fromExtern<Int64>(index[0])]
    }
    operator func [](index: Array<Extern<RT>>, value!: Int64): Unit {
        values[RT.fromExtern<Int64>(index[0])] = value
    }
}

class TupleIndex {
    let values = [10, 20]
    operator func [](index: (Extern<RT>, Int64)): Int64 {
        values[RT.fromExtern<Int64>(index[0])]
    }
    operator func [](index: (Extern<RT>, Int64), value!: Int64): Unit {
        values[RT.fromExtern<Int64>(index[0])] = value
    }
}

func check(name: String, ok: Bool, expectedConversions: Int64): Unit {
    if (!ok || conversions != expectedConversions) {
        throw Exception("${name}: conversions=${conversions}")
    }
    conversions = 0
}

main() {
    let a = ArrayIndex()
    a[[1, 0]] += 1
    check("array +=", a.values == [10, 21], 2)
    a[[0]]++
    check("array ++", a.values == [11, 21], 1)
    let t = TupleIndex()
    t[(1, 0)] += 1
    check("tuple +=", t.values == [10, 21], 1)
    t[(0, 0)]--
    check("tuple --", t.values == [9, 21], 1)
    0
}
