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
// Check shared copies and mutate only their fully local source.

import std.collection.*
import std.core.*

func gaListCopySize(a: ArrayList<Int64> @local?): Int64 {
    a.toArray().size
}

func gaListCopyIsIndependent(a: ArrayList<Int64> @local?): Bool {
    let copy: Array<Int64> @local? = a.toArray()
    copy[0] = 99
    a[0] == 1 && copy[0] == 99
}

func gaCloneSize(a: ArrayList<Int64> @local?): Int64 {
    a.clone().size
}

func gaCloneCapacity(a: ArrayList<Int64> @local?): Int64 {
    a.clone().capacity
}

exclave func gaCloneIsIndependent(a: ArrayList<Int64> @local!): Bool {
    let view: ArrayList<Int64> @local? = a
    let copy: ArrayList<Int64> @local? = view.clone()
    a[0] = 99
    let independent = copy[0] == 1 && a[0] == 99
    a[0] = 1
    independent
}

main(): Int64 {
    var failed = 0
    let owner: ArrayList<Int64> @local! = ArrayList<Int64>(8) @local!
    owner.add(1)
    owner.add(4)
    let q: ArrayList<Int64> @local? = owner
    failed += assertEq(gaListCopySize(q), 2, "GA16_toarray_local_q_size")
    failed += assertB(gaListCopyIsIndependent(q), "GA16_toarray_local_q_independent")
    failed += assertEq(gaCloneSize(q), 2, "GA15_clone_local_q_size")
    failed += assertEq(gaCloneCapacity(q), 8, "GA15_clone_local_q_capacity")
    failed += assertB(gaCloneIsIndependent(owner), "GA15_clone_local_q_independent")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
