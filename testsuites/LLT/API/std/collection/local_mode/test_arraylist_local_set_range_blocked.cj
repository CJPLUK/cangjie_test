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

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

exclave func checkRejectedRange(list: ArrayList<Int64> @local!, range: Range<Int64>, badStep: Bool): Unit {
    var caught = false
    if (badStep) {
        try { list.remove(range) }
        catch (_: IllegalArgumentException) { caught = true }
    } else {
        try { list.remove(range) }
        catch (_: IndexOutOfBoundsException) { caught = true }
    }
    check(caught, "invalid removal range must be rejected")
    check(list.size == 5 && list[0] == 1 && list[2] == 3 && list[4] == 5,
        "rejected removal must preserve all elements")
}

func checkRanges(): Unit {
    let source: Array<Int64> @local! = [1, 2, 3, 4, 5]
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(source) @local!
    let iterator: Iterator<Int64> @local! = list.iterator()
    checkRejectedRange(list, 0..4 : 2, true)
    checkRejectedRange(list, -1..1, false)
    checkRejectedRange(list, 0..6, false)
    list.remove(2..2)
    check(iterator.next().getOrThrow() == 1, "no-op and failed removals preserve iterator validity")
    list.remove(1..3)
    check(list.size == 3 && list[0] == 1 && list[1] == 4 && list[2] == 5, "open range removal")
    list.remove(1..=2)
    check(list.size == 1 && list[0] == 1, "closed range removal")
    list.remove(Range<Int64>(0, 0, 1, false, false, false))
    check(list.isEmpty(), "omitted endpoints remove the whole list")
    list.remove(0..0)
    check(list.isEmpty(), "empty range on an empty list")
}

main(): Int64 {
    checkRanges()
    println("ALL PASSED")
    0
}
