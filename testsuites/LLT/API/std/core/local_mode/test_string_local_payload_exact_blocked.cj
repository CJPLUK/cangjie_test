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
// Check exact Rune and String payloads returned by local iterators.

main(): Int64 {
    var failed = 0
    // Decode all four Unicode code points in order.
    let s233: String @local! = "A¢仓\u{1F600}"
    let rit: Iterator<Rune> @local! = s233.runes()
    let r1: ?Rune @local! = rit.next()
    match (r1) {
        case Some(r) => failed += assertB(r == r'A', "T233_rune_0")
        case None => failed += 1
        println("FAIL: T233_rune_0 — expected Some(A)")
    }
    let r2: ?Rune @local! = rit.next()
    match (r2) {
        case Some(r) => failed += assertB(r == r'\u{00A2}', "T233_rune_1")
        case None => failed += 1
        println("FAIL: T233_rune_1 — expected Some(cent)")
    }
    let r3: ?Rune @local! = rit.next()
    match (r3) {
        case Some(r) => failed += assertB(r == r'仓', "T233_rune_2")
        case None => failed += 1
        println("FAIL: T233_rune_2 — expected Some(cang)")
    }
    let r4: ?Rune @local! = rit.next()
    match (r4) {
        case Some(r) => failed += assertB(r == r'\u{1F600}', "T233_rune_3")
        case None => failed += 1
        println("FAIL: T233_rune_3 — expected Some(emoji)")
    }
    // Preserve every line across LF, CR, and CRLF separators.
    let s234: String @local! = "a\nb\rc\r\nd"
    let lit: Iterator<String> @local! = s234.lines()
    let l1: ?String @local! = lit.next()
    match (l1) {
        case Some(v) => failed += assertB(v == "a", "T234_line_0")
        case None => failed += 1
        println("FAIL: T234_line_0 — expected Some(a)")
    }
    let l2: ?String @local! = lit.next()
    match (l2) {
        case Some(v) => failed += assertB(v == "b", "T234_line_1")
        case None => failed += 1
        println("FAIL: T234_line_1 — expected Some(b)")
    }
    let l3: ?String @local! = lit.next()
    match (l3) {
        case Some(v) => failed += assertB(v == "c", "T234_line_2")
        case None => failed += 1
        println("FAIL: T234_line_2 — expected Some(c)")
    }
    let l4: ?String @local! = lit.next()
    match (l4) {
        case Some(v) => failed += assertB(v == "d", "T234_line_3")
        case None => failed += 1
        println("FAIL: T234_line_3 — expected Some(d)")
    }
    // Preserve empty lines while omitting a final line terminator.
    let nlSrc: String @local! = "\n"
    let nlOnly: Iterator<String> @local! = nlSrc.lines()
    let nlA: ?String @local! = nlOnly.next()
    match (nlA) {
        case Some(v) => failed += assertB(v == "", "T234_nl_only_emptyLine")
        case None => failed += 1
        println("FAIL: T234_nl_only — expected Some(empty)")
    }
    let anSrc: String @local! = "a\n"
    let an: Iterator<String> @local! = anSrc.lines()
    let anA: ?String @local! = an.next()
    match (anA) {
        case Some(v) => failed += assertB(v == "a", "T234_an_line")
        case None => failed += 1
        println("FAIL: T234_an — expected Some(a)")
    }
    let crrbSrc: String @local! = "a\r\rb"
    let crrb: Iterator<String> @local! = crrbSrc.lines()
    let crrbA: ?String @local! = crrb.next()
    match (crrbA) {
        case Some(v) => failed += assertB(v == "a", "T234_crrb_0")
        case None => failed += 1
        println("FAIL: T234_crrb_0 — expected Some(a)")
    }
    let crrbB: ?String @local! = crrb.next()
    match (crrbB) {
        case Some(v) => failed += assertB(v == "", "T234_crrb_1_empty")
        case None => failed += 1
        println("FAIL: T234_crrb_1 — expected Some(empty)")
    }
    let crrbC: ?String @local! = crrb.next()
    match (crrbC) {
        case Some(v) => failed += assertB(v == "b", "T234_crrb_2")
        case None => failed += 1
        println("FAIL: T234_crrb_2 — expected Some(b)")
    }
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
