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
// Check shared rune and line iterators through public APIs.

import std.core.*

func gaRuneCount(s: String @local?): Int64 {
    var count: Int64 = 0
    let it: Iterator<Rune> @local? = s.runes()
    while (true) {
        match (it.next()) {
            case Some(_) => count++
            case None => break
        }
    }
    count
}

func gaFirstRuneIsA(s: String @local?): Bool {
    let it: Iterator<Rune> @local? = s.runes()
    match (it.next()) {
        case Some(r) => r == r'A'
        case None => false
    }
}

func gaLineCount(s: String @local?): Int64 {
    var count: Int64 = 0
    let it: Iterator<String> @local? = s.lines()
    while (true) {
        match (it.next()) {
            case Some(_) => count++
            case None => break
        }
    }
    count
}

func gaFirstLine(s: String @local?): String {
    let it: Iterator<String> @local? = s.lines()
    match (it.next()) {
        case Some(l) => String(l)
        case None => "<none>"
    }
}

main(): Int64 {
    var failed = 0
    let heap: String = "A¢\nB\nC"
    let q: String @local? = heap
    failed += assertEq(gaRuneCount(q), 6, "GA11_runes_local_q_count")
    failed += assertB(gaFirstRuneIsA(q), "GA11_runes_local_q_first_payload")
    failed += assertEq(gaLineCount(q), 3, "GA12_lines_local_q_count")
    failed += assertEq(gaFirstLine(q), "A¢", "GA12_lines_local_q_first_payload")
    let empty: String @local? = ""
    failed += assertEq(gaRuneCount(empty), 0, "GA11_runes_local_q_empty")
    failed += assertEq(gaLineCount(empty), 0, "GA12_lines_local_q_empty")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
