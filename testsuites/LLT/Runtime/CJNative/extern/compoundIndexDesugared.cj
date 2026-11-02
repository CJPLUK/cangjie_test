// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// c[i] op= v, c[i]++ and c[i]-- evaluate the index i once when i is implicitly converted to Extern<T> for the getter
// and the setter, also when i was already desugared before the conversion: a block, a pipeline, an overloaded operator
// or a string interpolation.

var evaluations = 0

class RT <: ForeignRuntime<RT> {
    public static func toExtern<U>(value: U): Extern<RT> {
        Extern<RT>(value)
    }

    public static func fromExtern<U>(e: Extern<RT>): U {
        (Extern<RT>.getPayload(e) as U).getOrThrow()
    }

    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> {
        throw ExternMemberAccessException(field)
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
}

// The cell at index k holds the value 10 * k.
class Cells {
    var reads = 0
    var readKey = -1
    var writes = 0
    var writeKey = -1
    var writeValue = -1

    func key(index: Extern<RT>): Int64 {
        match (Extern<RT>.getPayload(index)) {
            case n: Int64 => n
            case s: String where s == "1" => 1
            case v: V => v.n
            case _ => throw Exception("unexpected index")
        }
    }

    operator func [](index: Extern<RT>): Int64 {
        reads++
        readKey = key(index)
        10 * readKey
    }

    operator func [](index: Extern<RT>, value!: Int64): Unit {
        writes++
        writeKey = key(index)
        writeValue = value
    }
}

struct V {
    let n: Int64
    init(n: Int64) {
        this.n = n
    }
    operator func +(o: V): V {
        evaluations++
        V(n + o.n)
    }
}

func next(): Int64 {
    evaluations++
    evaluations
}

func id(x: Int64): Int64 {
    x
}

func check(name: String, c: Cells, expectedKey: Int64, expectedValue: Int64): Unit {
    let ok = evaluations == 1 && c.reads == 1 && c.readKey == expectedKey && c.writes == 1 &&
        c.writeKey == expectedKey && c.writeValue == expectedValue
    if (!ok) {
        throw Exception("${name}: evaluations=${evaluations}, read ${c.readKey}, wrote ${c.writeValue} at ${c.writeKey}")
    }
    evaluations = 0
    c.reads = 0
    c.writes = 0
}

main() {
    let c = Cells()

    c[unsafe { next() }] += 1
    check("block +=", c, 1, 11)
    c[unsafe { next() }]++
    check("block ++", c, 1, 11)
    c[unsafe { next() }]--
    check("block --", c, 1, 9)

    c[next() |> id] += 1
    check("pipeline +=", c, 1, 11)
    c[next() |> id]++
    check("pipeline ++", c, 1, 11)

    c[V(1) + V(2)] += 1
    check("operator +=", c, 3, 31)
    c[V(1) + V(2)]--
    check("operator --", c, 3, 29)

    c["${next()}"] += 1
    check("interpolation +=", c, 1, 11)
    c["${next()}"]++
    check("interpolation ++", c, 1, 11)
    0
}
