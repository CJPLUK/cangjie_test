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

func check(condition: Bool, message: String): Unit {
    if (!condition) {
        println("CHECK FAILED: ${message}")
        throw Exception(message)
    }
}

func expectInvalidSlice(list: ArrayList<Int64> @local?, range: Range<Int64>): Unit {
    var rejected = false
    try {
        let _: ArrayList<Int64> @local? = list.slice(range)
    } catch (_: IndexOutOfBoundsException) {
        rejected = true
    }
    check(rejected, "slice must reject a range beyond the logical size")
}

func testArrayListSlice(): Unit {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(16)
    list.add(7)
    list.add(8)
    let view: ArrayList<Int64> @local? = list
    let whole: ArrayList<Int64> @local? = view[..]
    check(whole.size == 2 && whole[0] == 7 && whole[1] == 8,
        "an open-ended slice must stop at the logical size")
    let closed: ArrayList<Int64> @local? = view.slice(0..=1)
    check(closed.size == 2, "a valid closed slice must include its last element")
    let empty: ArrayList<Int64> @local? = view[2..2]
    check(empty.size == 0, "an empty slice at the logical end must be valid")
    expectInvalidSlice(view, 0..3)
    expectInvalidSlice(view, 0..=2)
    expectInvalidSlice(view, 3..3)

    var rejected = false
    try {
        let _: ArrayList<Int64> @local? = view[0..3]
    } catch (_: IndexOutOfBoundsException) {
        rejected = true
    }
    check(rejected, "the range operator must reject unused capacity")

    let emptyList: ArrayList<Int64> @local! = ArrayList<Int64>(16)
    let emptyView: ArrayList<Int64> @local? = emptyList
    let emptyWhole: ArrayList<Int64> @local? = emptyView[..]
    check(emptyWhole.size == 0, "slicing an empty list must not expose its capacity")
    expectInvalidSlice(emptyView, 0..1)
}

main(): Int64 {
    testArrayListSlice()
    println("ALL PASSED")
    return 0
}
