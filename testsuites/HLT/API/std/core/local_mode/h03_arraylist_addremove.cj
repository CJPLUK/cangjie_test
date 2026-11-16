/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

// ArrayList 在 local region 内的增删循环不触发 GC：构造、add、remove 都在同一
// local region 完成，容量预留避免中途扩容。
//
// 注：`@local?` 接收者没有 add/remove 重载（只有 `@local!`），因此用 `@local!`；
// `ArrayList<Int64>()` 的 `@local?` 空构造可用，但不参与本增删循环。

import std.runtime.*
import std.collection.*
import std.core.*

func assertEq<T>(actual: T, expected: T, name: String): Int64 where T <: ToString & Equatable<T> {
    if (actual != expected) {
        println("FAIL: ${name} — expected ${expected}, got ${actual}")
        return 1
    }
    return 0
}

func assertB(actual: Bool, name: String): Int64 {
    if (!actual) {
        println("FAIL: ${name} — expected true, got false")
        return 1
    }
    return 0
}

exclave func runLocalList(): ArrayList<Int64> @local! {
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(1024) @local!
    for (i in 0..512) {
        list.add(i)
    }
    for (_ in 0..256) {
        list.remove(at: 0)
    }
    list
}

main(): Int64 {
    var failed = 0

    // GC baseline
    GC(heavy: true)
    let before = getGCCount()

    let list = runLocalList()

    let after = getGCCount()

    failed += assertB(after - before <= 1, "h03_gc_tolerance")
    failed += assertEq(list.size, 256, "h03_size")
    failed += assertEq(list[0], 256, "h03_elem0")
    failed += assertEq(list[255], 511, "h03_elem255")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
