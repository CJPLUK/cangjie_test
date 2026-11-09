/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.collection.*

class LocalNumbers <: Collection<Int64> {
    let items: Array<Int64>
    init(items: Array<Int64>) { this.items = items }
    exclave init(this @local!, items: Array<Int64> @local!) { this.items = items }
    public prop size: Int64 { get() { items.size } }
    public func isEmpty(): Bool { items.isEmpty() }
    public func isEmpty(this @local?): Bool { items.isEmpty() }
    public func iterator(): Iterator<Int64> { items.iterator() }
    public exclave func iterator(this @local!): Iterator<Int64> @local! { items.iterator() }
    public func toArray(): Array<Int64> { items.clone() }
    public func toArray(this @local!): Array<Int64> @local! { items }
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkList(actual: ArrayList<Int64> @local?, expected: Array<Int64>): Unit {
    check(actual.size == expected.size, "bulk insertion size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "bulk insertion contents") }
}

exclave func checkInsert(source: Collection<Int64> @local!, capacity: Int64, at: Int64): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(capacity) @local!
    list.add(1); list.add(2)
    list.add(all: source, at: at)
    if (at == 0) { checkList(list, [7, 8, 1, 2]) }
    else if (at == 1) { checkList(list, [1, 7, 8, 2]) }
    else { checkList(list, [1, 2, 7, 8]) }
}

func checkSourceKinds(): Unit {
    let data: Array<Int64> @local! = [7, 8]
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(data) @local!
    let other: LocalNumbers @local! = LocalNumbers(data) @local!
    for (capacity in [2, 16]) {
        for (at in 0..3) {
            checkInsert(data, capacity, at)
            checkInsert(list, capacity, at)
            checkInsert(other, capacity, at)
        }
    }
    check(data[0] == 7 && data[1] == 8 && list[0] == 7 && list[1] == 8, "sources must remain unchanged")
    let appended: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    appended.add(1)
    appended.add(all: other)
    checkList(appended, [1, 7, 8])
}

func checkEmptyAndInvalidIndex(): Unit {
    let data: Array<Int64> @local! = []
    let source: LocalNumbers @local! = LocalNumbers(data) @local!
    let list: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    list.add(1)
    let iterator: Iterator<Int64> @local! = list.iterator()
    list.add(all: source, at: 1)
    checkList(list, [1])
    check(iterator.next().getOrThrow() == 1, "empty insertion must not invalidate an iterator")
    for (at in [-1, 2]) {
        var caught = false
        try { list.add(all: source, at: at) }
        catch (_: IndexOutOfBoundsException) { caught = true }
        check(caught, "insertion index checked even for empty source")
        checkList(list, [1])
    }
}

func checkAliasing(): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    list.add(1); list.add(2); list.add(3); list.add(4)
    let source: ArrayList<Int64> @local! = list.slice(2..4)
    list.add(all: source, at: 0)
    checkList(list, [3, 4, 1, 2, 3, 4])
    let self: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    self.add(1); self.add(2); self.add(3)
    self.add(all: self, at: 1)
    checkList(self, [1, 1, 2, 3, 2, 3])
}

main(): Int64 {
    checkEmptyAndInvalidIndex()
    checkAliasing()
    checkSourceKinds()
    println("ALL PASSED")
    0
}
