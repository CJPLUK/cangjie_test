/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// FIXED（2026-09-15）：根因是 Ordering 类型自身缺 @local? 覆写——@local? Ordering
//   结果上的 ==/compare 落接口默认(throw)。std.core comparable.cj 的
//   extend Ordering <: Comparable<Ordering> 已补 compare/==/!= 的 @local? 覆写,
//   本用例恢复活跃。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.core.*

func t429StringCompareCase(receiver: String @local!, other: String @local!, expected: Ordering, name: String): Int64 {
    exclave {
        let comparable: Comparable<String> @local? = receiver
        try {
            let actual: Ordering @local? = comparable.compare(other)
            if (actual == expected) {
                0
            } else {
                println("FAIL: ${name} — expected the documented Ordering")
                1
            }
        } catch (e: UnimplementedException) {
            println("FAIL: ${name} — expected String compare, got UnimplementedException")
            1
        }
    }
}

func t434HeapOther(receiver: String @local!, other: String, name: String): Int64 {
    exclave {
        let comparable: Comparable<String> @local? = receiver
        try {
            let actual: Ordering @local? = comparable.compare(other)
            if (actual == Ordering.LT) { 0 } else {
                println("FAIL: ${name} — expected LT")
                1
            }
        } catch (e: UnimplementedException) {
            println("FAIL: ${name} — expected LT, got UnimplementedException")
            1
        }
    }
}

func t434FullOther(receiver: String @local!, other: String @local!, name: String): Int64 {
    exclave {
        let comparable: Comparable<String> @local? = receiver
        try {
            let actual: Ordering @local? = comparable.compare(other)
            if (actual == Ordering.LT) { 0 } else {
                println("FAIL: ${name} — expected LT")
                1
            }
        } catch (e: UnimplementedException) {
            println("FAIL: ${name} — expected LT, got UnimplementedException")
            1
        }
    }
}

func t434HalfOther(receiver: String @local!, other: String @local?, name: String): Int64 {
    exclave {
        let comparable: Comparable<String> @local? = receiver
        try {
            let actual: Ordering @local? = comparable.compare(other)
            if (actual == Ordering.LT) { 0 } else {
                println("FAIL: ${name} — expected LT")
                1
            }
        } catch (e: UnimplementedException) {
            println("FAIL: ${name} — expected LT, got UnimplementedException")
            1
        }
    }
}

main(): Int64 {
    var failed = 0

    // T429: String's documented compare matrix through Comparable<String> @local?.
    let a1: String @local! = "a"
    let a2: String @local! = "a"
    let b1: String @local! = "b"
    let b2: String @local! = "b"
    let ab: String @local! = "ab"
    failed += t429StringCompareCase(a1, a2, Ordering.EQ, "T429_string_aa_eq")
    failed += t429StringCompareCase(a1, b1, Ordering.LT, "T429_string_ab_lt")
    failed += t429StringCompareCase(b2, a1, Ordering.GT, "T429_string_ba_gt")
    failed += t429StringCompareCase(ab, a1, Ordering.GT, "T429_string_aba_gt_by_length")
    failed += t429StringCompareCase(a1, ab, Ordering.LT, "T429_string_aab_lt_by_length")

    // T434: one local? receiver must accept heap, full, and half other values.
    let receiver: String @local! = "a"
    let heapOther: String = "b"
    let fullOther: String @local! = "b"
    let halfOther: String @local? = fullOther
    failed += t434HeapOther(receiver, heapOther, "T434_other_heap_lt")
    failed += t434FullOther(receiver, fullOther, "T434_other_full_lt")
    failed += t434HalfOther(receiver, halfOther, "T434_other_half_lt")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
