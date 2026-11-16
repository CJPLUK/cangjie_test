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
//
// 覆盖设计项（LM-DOC-20260910）：T228（get/[] 字节矩阵）、T232 与 T233 的
// byte/Int64 精确 payload（本 SDK 已修复）；T233 的 Rune payload 与 T234 的
// String 行 payload 仍损坏，见 test_string_local_payload_exact_blocked.cj。
// T229/T230（String[](Range) local!/local? 切片）在本 SDK 缺失对应重载，
// 见 test_string_local_get_range_blocked.cj。
// 设计编号命名空间：LM-DOC-20260910。

// S220 fixture：A¢仓\u{1F600}，bytes offsets [0,1,3,6,10]，size=10
func size220(): Int64 {
    10
}

main(): Int64 {
    var failed = 0

    // T228: get @local? 全字节矩阵（含 -1/size 越界 None）
    let s228: String @local? = "A¢仓\u{1F600}"
    let o228a: Option<Byte> = s228.get(0)
    failed += assertB(o228a.getOrThrow() == 0x41u8, "T228_get_0")
    let o228b: Option<Byte> = s228.get(1)
    failed += assertB(o228b.getOrThrow() == 0xC2u8, "T228_get_1_lead")
    let o228c: Option<Byte> = s228.get(2)
    failed += assertB(o228c.getOrThrow() == 0xA2u8, "T228_get_2_cont")
    let o228d: Option<Byte> = s228.get(3)
    failed += assertB(o228d.getOrThrow() == 0xE4u8, "T228_get_3_lead")
    let o228e: Option<Byte> = s228.get(6)
    failed += assertB(o228e.getOrThrow() == 0xF0u8, "T228_get_6_lead")
    let o228f: Option<Byte> = s228.get(9)
    failed += assertB(o228f.getOrThrow() == 0x80u8, "T228_get_9_cont")
    let negIdx: Int64 = -1
    let o228g: Option<Byte> = s228.get(negIdx)
    failed += assertB(o228g.isNone(), "T228_get_neg_none")
    let ooIdx: Int64 = size220()
    let o228h: Option<Byte> = s228.get(ooIdx)
    failed += assertB(o228h.isNone(), "T228_get_size_none")

    // T228: [](index) @local? 合法字节 + 越界异常（动态索引防常量折叠）
    failed += assertEq(s228[0], 0x41u8, "T228_index_0")
    failed += assertEq(s228[2], 0xA2u8, "T228_index_2")
    failed += assertEq(s228[9], 0x80u8, "T228_index_9")
    try {
        let _ = s228[negIdx]
        failed += 1
        println("FAIL: T228_index_negative — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        let _ = s228[ooIdx]
        failed += 1
        println("FAIL: T228_index_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    // T228: local! receiver 的 [](index)
    let s228l: String @local! = "A¢仓\u{1F600}"
    failed += assertEq(s228l[3], 0xE4u8, "T228_index_local_bang")

    // T232: heap-backed @local? 的 byte iterator 精确 payload 与重复终止
    let heap232: String = "A¢"
    let q232: String @local? = heap232
    let it232: Iterator<Byte> @local? = q232.iterator()
    let p232a: ?Byte @local? = it232.next()
    match (p232a) {
        case Some(b) => failed += assertEq(b, 0x41u8, "T232_next_0")
        case None => failed += 1
        println("FAIL: T232_next_0 — expected Some(0x41)")
    }
    let p232b: ?Byte @local? = it232.next()
    match (p232b) {
        case Some(b) => failed += assertEq(b, 0xC2u8, "T232_next_1")
        case None => failed += 1
        println("FAIL: T232_next_1 — expected Some(0xC2)")
    }
    let p232c: ?Byte @local? = it232.next()
    match (p232c) {
        case Some(b) => failed += assertEq(b, 0xA2u8, "T232_next_2")
        case None => failed += 1
        println("FAIL: T232_next_2 — expected Some(0xA2)")
    }
    let p232d: ?Byte @local? = it232.next()
    match (p232d) {
        case Some(_) => failed += 1
        println("FAIL: T232_exhausted — expected None")
        case None => failed += assertB(true, "T232_exhausted_none")
    }
    let p232e: ?Byte @local? = it232.next()
    match (p232e) {
        case None => failed += assertB(true, "T232_exhausted_repeat")
        case Some(_) => failed += 1
        println("FAIL: T232_exhausted_repeat — expected None")
    }

    // T233: local! byte iterator 精确 10 字节 + runes 精确 4 项（C7 已修复）
    let s233: String @local! = "A¢仓\u{1F600}"
    let it233: Iterator<Byte> @local! = s233.iterator()
    let expect233: Array<UInt8> = [0x41u8, 0xC2u8, 0xA2u8, 0xE4u8, 0xBBu8, 0x93u8, 0xF0u8, 0x9Fu8, 0x98u8, 0x80u8]
    var idx233: Int64 = 0
    var done233 = false
    while (!done233) {
        let o: ?Byte @local! = it233.next()
        match (o) {
            case Some(b) =>
                failed += assertEq(b, expect233[idx233], "T233_byte")
                idx233 += 1
            case None => done233 = true
        }
    }
    let rit233: Iterator<Rune> @local! = s233.runes()
    // T233: runes 精确 payload 受本 SDK 仍存在的 C7-Rune 变体阻塞（Byte/Int64 payload
    // 已修复、Rune/String payload 仍损坏），此处保留计数与终止结构；
    // 精确 Rune payload 期望见 test_string_local_payload_exact_blocked.cj
    var rCount233: Int64 = 0
    var rDone233 = false
    while (!rDone233) {
        let o: ?Rune @local! = rit233.next()
        match (o) {
            case Some(_) =>
                rCount233 += 1
            case None => rDone233 = true
        }
    }
    failed += assertEq(rCount233, 4, "T233_rune_count")
    let r233f: ?Rune @local! = rit233.next()
    match (r233f) {
        case Some(_) => failed += 1
        println("FAIL: T233_rune_exhausted_repeat — expected None")
        case None => failed += assertB(true, "T233_rune_exhausted_repeat")
    }

    // T234: lines 精确 String payload 受本 SDK 引用 payload 屏障阻塞，此处保留
    // 行数与终止结构；精确行内容期望见 test_string_local_payload_exact_blocked.cj
    let s234: String @local! = "a\nb\rc\r\nd"
    let lit234: Iterator<String> @local! = s234.lines()
    var lineCount234: Int64 = 0
    var lineDone234 = false
    while (!lineDone234) {
        let o: ?String @local! = lit234.next()
        match (o) {
            case Some(_) =>
                lineCount234 += 1
            case None => lineDone234 = true
        }
    }
    failed += assertEq(lineCount234, 4, "T234_lines_count")
    let e234: String @local! = ""
    let le234: Iterator<String> @local! = e234.lines()
    let le234a: ?String @local! = le234.next()
    match (le234a) {
        case Some(_) => failed += 1
        println("FAIL: T234_lines_empty — expected None")
        case None => failed += assertB(true, "T234_lines_empty_none")
    }
    let nl234: String @local! = "\n"
    let ln234: Iterator<String> @local! = nl234.lines()
    let ln234a: ?String @local! = ln234.next()
    match (ln234a) {
        case Some(_) =>
            failed += assertB(true, "T234_lines_nl_oneLine")
        case None => failed += 1
        println("FAIL: T234_lines_nl — expected Some")
    }
    let an234: String @local! = "a\n"
    let lan234: Iterator<String> @local! = an234.lines()
    var anCount234: Int64 = 0
    var anDone234 = false
    while (!anDone234) {
        let o: ?String @local! = lan234.next()
        match (o) {
            case Some(_) =>
                anCount234 += 1
            case None => anDone234 = true
        }
    }
    failed += assertEq(anCount234, 1, "T234_lines_an_count")
    let cr234: String @local! = "a\r\rb"
    let lcr234: Iterator<String> @local! = cr234.lines()
    var crCount234: Int64 = 0
    var crDone234 = false
    while (!crDone234) {
        let o: ?String @local! = lcr234.next()
        match (o) {
            case Some(_) =>
                crCount234 += 1
            case None => crDone234 = true
        }
    }
    failed += assertEq(crCount234, 3, "T234_lines_cr_count")
    let lcr234z: ?String @local! = lcr234.next()
    match (lcr234z) {
        case Some(_) => failed += 1
        println("FAIL: T234_lines_cr_exhausted_repeat — expected None")
        case None => failed += assertB(true, "T234_lines_cr_exhausted_repeat")
    }

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
