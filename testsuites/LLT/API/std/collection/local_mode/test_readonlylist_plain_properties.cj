// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %cmp_opt_chir2hlir -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt_chir2hlir -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.collection.*

class PlainList <: ReadOnlyList<Int64> {
    private let data = ArrayList<Int64>()
    public prop size: Int64 { get() { data.size } }
    public prop first: ?Int64 { get() { data.first } }
    public prop last: ?Int64 { get() { data.last } }
    public func isEmpty(): Bool { data.isEmpty() }
    public func iterator(): Iterator<Int64> { data.iterator() }
    public func get(index: Int64): ?Int64 { data.get(index) }
    public operator func [](index: Int64): Int64 { data[index] }
    public func add(value: Int64): Unit { data.add(value) }
}

func checkEnds(list: ReadOnlyList<Int64>, first: ?Int64, last: ?Int64): Unit {
    if (list.first != first || list.last != last) {
        throw Exception("Plain ReadOnlyList first/last must dispatch to the concrete getters")
    }
}

main(): Int64 {
    let array = ArrayList<Int64>()
    let custom = PlainList()
    checkEnds(array, None, None)
    checkEnds(custom, None, None)
    array.add(3)
    array.add(5)
    custom.add(3)
    custom.add(5)
    checkEnds(array, Some(3), Some(5))
    checkEnds(custom, Some(3), Some(5))
    println("Plain ReadOnlyList properties passed")
    0
}
