/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
// T319: an ArrayList @local! grows its storage when an append exceeds the free
// capacity. CJEEP-005 keeps the growth on the class body as @local!; `reserve` has
// no local form in the baseline, so growth is driven through `add`, which is the
// documented path that raises the capacity.
import std.collection.*
import std.core.*

func t319Grow(list: ArrayList<Int64> @local!, appended: Int64): Int64 {
    exclave {
        let before: Int64 = list.capacity
        let beforeSize: Int64 = list.size
        list.add(appended)
        let after: Int64 = list.capacity
        if (list.size != beforeSize + 1 || after < list.size) { return 1 }
        if (after < before) { return 1 }
        0
    }
}

main(): Int64 {
    var failed = 0

    // Full capacity: the append must grow the backing storage.
    let full: ArrayList<Int64> @local! = ArrayList<Int64>(2) @local!
    full.add(1)
    full.add(2)
    let fullBefore: Int64 = full.capacity
    failed += assertEq(t319Grow(full, 3), 0, "T319_grow_at_full_capacity")
    failed += assertB(full.capacity > fullBefore, "T319_capacity_increased")

    // Zero capacity: the first append must allocate.
    let zero: ArrayList<Int64> @local! = ArrayList<Int64>(0) @local!
    failed += assertEq(t319Grow(zero, 1), 0, "T319_grow_from_zero_capacity")

    // Spare capacity: the append must not relocate the storage.
    let spare: ArrayList<Int64> @local! = ArrayList<Int64>(8) @local!
    spare.add(1)
    let spareBefore: Int64 = spare.capacity
    failed += assertEq(t319Grow(spare, 2), 0, "T319_append_within_free_capacity")
    failed += assertB(spare.capacity == spareBefore, "T319_capacity_unchanged")

    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
