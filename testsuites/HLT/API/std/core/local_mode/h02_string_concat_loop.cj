/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

// String @local! 循环拼接不触发 GC：`operator func +(this @local!, right: String)`
// 由 std 库提供，结果留在同一 local region，循环本身不产生堆对象。
//
// 注：`@local?` 接收者没有 `+` 重载（只有 `@local!`），因此用 `@local!` 接收者。

import std.runtime.*
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

exclave func buildLocalString(): String @local! {
    var s: String @local! = ""
    for (i in 0..1000) {
        s = s + "x"
    }
    s
}

main(): Int64 {
    var failed = 0

    // GC baseline
    GC(heavy: true)
    let before = getGCCount()

    let s: String @local! = buildLocalString()

    let after = getGCCount()

    failed += assertB(after - before <= 1, "h02_gc_tolerance")
    failed += assertEq(s.size, 1000, "h02_size")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
