/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// UPDATE 2026-09-11: SDK local_mode-localmods-20260911-final 已修复本文件原阻塞器，恢复 EXEC（原阻塞记录见下）。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// BLOCKED (LM-DOC-20260910 T308, RT-1): each fresh iterator must throw the
// doc-correct ConcurrentModificationException after a real add/remove/clear/
// reverse.  This file deliberately performs the writes; the 0907 runtime
// aborts first with `F Barrier::WriteGeneric does not support local object`.

import std.collection.*
import std.core.*

func afterAdd(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        a.add(9)
        try {
            let _ = it.next()
            1
        } catch (e: ConcurrentModificationException) {
            0
        }
    }
}

func afterRemove(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        a.remove(at: 0)
        try {
            let _ = it.next()
            1
        } catch (e: ConcurrentModificationException) {
            0
        }
    }
}

func afterClear(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        a.clear()
        try {
            let _ = it.next()
            1
        } catch (e: ConcurrentModificationException) {
            0
        }
    }
}

func afterReverse(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        a.reverse()
        try {
            let _ = it.next()
            1
        } catch (e: ConcurrentModificationException) {
            0
        }
    }
}

main(): Int64 {
    var failed = 0
    let s1: Array<Int64> @local! = [1, 2]
    let a1: ArrayList<Int64> @local! = ArrayList<Int64>(s1) @local!
    failed += assertEq(afterAdd(a1), 0, "T308_after_add_concurrent_modification")
    let s2: Array<Int64> @local! = [1, 2]
    let a2: ArrayList<Int64> @local! = ArrayList<Int64>(s2) @local!
    failed += assertEq(afterRemove(a2), 0, "T308_after_remove_concurrent_modification")
    let s3: Array<Int64> @local! = [1, 2]
    let a3: ArrayList<Int64> @local! = ArrayList<Int64>(s3) @local!
    failed += assertEq(afterClear(a3), 0, "T308_after_clear_concurrent_modification")
    let s4: Array<Int64> @local! = [1, 2]
    let a4: ArrayList<Int64> @local! = ArrayList<Int64>(s4) @local!
    failed += assertEq(afterReverse(a4), 0, "T308_after_reverse_concurrent_modification")
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
