// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static var conversions = 0

    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (e) {
            case ExternPayload(value) => (value as R).getOrThrow()
            case _ => throw ExternConversionException("not a payload")
        }
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        conversions++
        Extern<DummyRT>.ExternPayload(v)
    }
}

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func expectConversions(n: Int64, msg: String): Unit {
    check(DummyRT.conversions == n, "${msg}: ${DummyRT.conversions} conversions, expected ${n}")
    DummyRT.conversions = 0
}

func size(a: Array<Extern<DummyRT>>): Int64 {
    a.size
}

func second(t: (Int64, Extern<DummyRT>)): String {
    DummyRT.fromExtern<String>(t[1])
}

func elements(): Array<Extern<DummyRT>> {
    [1, "two"]
}

main() {
    let a: Array<Extern<DummyRT>> = [1, "two", 3.0]
    expectConversions(3, "array elements")
    check(DummyRT.fromExtern<String>(a[1]) == "two", "array element")

    let e: Extern<DummyRT> = a[0]
    let mixed: Array<Extern<DummyRT>> = [e, 2]
    expectConversions(1, "Extern array element")
    check(DummyRT.fromExtern<Int64>(mixed[0]) == 1, "Extern array element was wrapped again")

    let whole: Extern<DummyRT> = [1, 2]
    expectConversions(1, "whole array")
    check(DummyRT.fromExtern<Array<Int64>>(whole).size == 2, "whole array")

    let nested: Array<Array<Extern<DummyRT>>> = [[1], [2, "three"]]
    expectConversions(3, "nested array")
    check(DummyRT.fromExtern<String>(nested[1][1]) == "three", "nested array")

    let t: (Extern<DummyRT>, Int64, Extern<DummyRT>) = (1, 2, "x")
    expectConversions(2, "tuple components")
    check(t[1] == 2 && DummyRT.fromExtern<String>(t[2]) == "x", "tuple components")

    let nestedTuple: (Array<Extern<DummyRT>>, (Extern<DummyRT>, Int64)) = ([1], (2, 3))
    expectConversions(2, "nested tuple")
    check(DummyRT.fromExtern<Int64>(nestedTuple[1][0]) == 2, "nested tuple")

    check(size([1, 2]) == 2, "array argument")
    expectConversions(2, "array argument")

    check(second((1, "y")) == "y", "tuple argument")
    expectConversions(1, "tuple argument")

    check(elements().size == 2, "returned array")
    expectConversions(2, "returned array")

    var assigned: Array<Extern<DummyRT>> = []
    assigned = [4]
    expectConversions(1, "assigned array")
    check(DummyRT.fromExtern<Int64>(assigned[0]) == 4, "assigned array")
    0
}
