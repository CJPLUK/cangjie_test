/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

// 跨 mode 构造：`String(value: String @local?)` 产生堆 String 副本，local 值经该
// 构造逃逸出 region 后内容仍然存活。

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

func makeEscapedString(): String {
    let localArray: Array<String> @local! = ["a", "bee", "c"]
    let localValue: String @local? = localArray[1]
    String(localValue)
}

main(): Int64 {
    var failed = 0

    // GC baseline
    GC(heavy: true)
    let before = getGCCount()

    let escaped = makeEscapedString()

    let mid = getGCCount()
    let after = getGCCount()
    let freed = getGCFreedSize()

    failed += assertEq(escaped, "bee", "h04_escaped")
    failed += assertB(mid >= before, "h04_mid_ge_before")
    failed += assertB(freed >= 0, "h04_freed_ge_0")
    failed += assertB(after - before <= 1, "h04_gc_tolerance")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
