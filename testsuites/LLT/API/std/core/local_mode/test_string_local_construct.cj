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
// 覆盖设计项（LM-DOC-20260910）：T200/T201/T204/T209/T211。
// T202/T203（Collection<Rune> 构造）与 T201 的 QH/QL Rune 数组入参在本 SDK 缺失
// 对应重载，见 test_string_local_construct_blocked.cj。
// 设计编号命名空间：LM-DOC-20260910。

main(): Int64 {
    var failed = 0

    // T200: @local! 空构造；String.empty；size/isEmpty/toArray
    let s1: String @local! = String() @local!
    failed += assertB(s1.isEmpty(), "T200_empty_isEmpty")
    failed += assertEq(s1.size, 0, "T200_empty_size")
    failed += assertEq(s1.toArray().size, 0, "T200_empty_toArray_size")
    let emptyConst = String.empty
    failed += assertEq(emptyConst.size, 0, "T200_emptyConst_size")
    failed += assertB(emptyConst.isEmpty(), "T200_emptyConst_isEmpty")

    // T201: 含 2/3/4 字节码点与 NUL 的 String @local!（字面量绑定；Rune 数组构造
    // 在本 SDK 为未定义符号，见 test_string_local_construct_blocked.cj）
    // bytes = 41 C2 A2 E4 BB 93 F0 9F 98 80 00, size=11, 5 Rune
    let s2: String @local! = "A¢仓\u{1F600}\u{0000}"
    failed += assertEq(s2.size, 11, "T201_unicode_size")
    let raw2: Array<Byte> @local! = s2.toArray()
    failed += assertEq(raw2.size, 11, "T201_toArray_size")
    failed += assertEq(raw2[0], 0x41u8, "T201_bytes_0")
    failed += assertEq(raw2[1], 0xC2u8, "T201_bytes_1")
    failed += assertEq(raw2[2], 0xA2u8, "T201_bytes_2")
    failed += assertEq(raw2[3], 0xE4u8, "T201_bytes_3")
    failed += assertEq(raw2[5], 0x93u8, "T201_bytes_5")
    failed += assertEq(raw2[6], 0xF0u8, "T201_bytes_6")
    failed += assertEq(raw2[10], 0x00u8, "T201_bytes_10_nul")
    let runes2: Array<Rune> @local! = s2.toRuneArray()
    failed += assertEq(runes2.size, 5, "T201_toRuneArray_size")
    failed += assertB(runes2[0] == r'A', "T201_rune_0")
    failed += assertB(runes2[2] == r'仓', "T201_rune_2")
    failed += assertB(runes2[4] == r'\u{0000}', "T201_rune_4_nul")

    // T204: heap-backed String @local? 分别经 local 拷贝构造与 heap 拷贝构造
    let heap204: String = "H¢"
    let q204: String @local? = heap204
    let s204a: String @local! = String(q204)
    failed += assertB(s204a == "H¢", "T204_heapQ_toLocal_value")
    failed += assertEq(s204a.size, 3, "T204_heapQ_toLocal_size")
    failed += assertEq(s204a.toArray()[0], 0x48u8, "T204_heapQ_toLocal_bytes0")
    let s204b: String = String(q204)
    failed += assertB(s204b == "H¢", "T204_heapQ_toHeap_value")
    failed += assertEq(s204b.size, 3, "T204_heapQ_toHeap_size")

    // T209: checked fromUtf8 全量字节 [41,C2,A2,E4,BB,93,F0,9F,98,80,00]（QH 来源）
    let bytes209: Array<UInt8> @local? = [0x41u8, 0xC2u8, 0xA2u8, 0xE4u8, 0xBBu8, 0x93u8, 0xF0u8, 0x9Fu8, 0x98u8, 0x80u8, 0x00u8]
    let s209: String @local! = String.fromUtf8(bytes209)
    failed += assertEq(s209.size, 11, "T209_checked_size")
    let raw209: Array<Byte> @local! = s209.toArray()
    failed += assertEq(raw209[1], 0xC2u8, "T209_checked_bytes_1")
    failed += assertEq(raw209[6], 0xF0u8, "T209_checked_bytes_6")
    failed += assertEq(raw209[10], 0x00u8, "T209_checked_bytes_10")
    // T209: checked fromUtf8（QL 来源：local! 数组 widen）
    let bytes209l: Array<UInt8> @local! = [0x41u8, 0xE4u8, 0xBBu8, 0x93u8]
    let s209l: String @local! = String.fromUtf8(bytes209l)
    failed += assertB(s209l == "A仓", "T209_checked_QL_value")

    // T210: checked fromUtf8 非法 UTF-8 分区：stray/truncated/overlong/surrogate/超最大码点
    let bad210a: Array<UInt8> @local? = [0x80u8]
    let bad210b: Array<UInt8> @local? = [0xC2u8]
    let bad210c: Array<UInt8> @local? = [0xC0u8, 0x80u8]
    let bad210d: Array<UInt8> @local? = [0xE0u8, 0x80u8, 0x80u8]
    let bad210e: Array<UInt8> @local? = [0xEDu8, 0xA0u8, 0x80u8]
    let bad210f: Array<UInt8> @local? = [0xF0u8, 0x80u8, 0x80u8, 0x80u8]
    let bad210g: Array<UInt8> @local? = [0xF4u8, 0x90u8, 0x80u8, 0x80u8]
    try {
        let _ = String.fromUtf8(bad210a)
        failed += 1
        println("FAIL: T210_stray_continuation — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210b)
        failed += 1
        println("FAIL: T210_truncated_2byte — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210c)
        failed += 1
        println("FAIL: T210_overlong_2byte — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210d)
        failed += 1
        println("FAIL: T210_overlong_3byte — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210e)
        failed += 1
        println("FAIL: T210_surrogate_ED — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210f)
        failed += 1
        println("FAIL: T210_overlong_4byte — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210g)
        failed += 1
        println("FAIL: T210_over_max_codepoint — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    // T210: 合法 F0 90 80 80 后逐次仅破坏 b2/b3/b4 continuation
    let bad210h: Array<UInt8> @local? = [0xF0u8, 0x28u8, 0x80u8, 0x80u8]
    let bad210i: Array<UInt8> @local? = [0xF0u8, 0x90u8, 0x28u8, 0x80u8]
    let bad210j: Array<UInt8> @local? = [0xF0u8, 0x90u8, 0x80u8, 0x28u8]
    try {
        let _ = String.fromUtf8(bad210h)
        failed += 1
        println("FAIL: T210_b2_continuation — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210i)
        failed += 1
        println("FAIL: T210_b3_continuation — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = String.fromUtf8(bad210j)
        failed += 1
        println("FAIL: T210_b4_continuation — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    // T211: unsafe static fromUtf8Unchecked（权威 overload）：QH 空数组与 QH/QL 有效序列
    let empty211: Array<UInt8> @local? = []
    let s211a: String @local! = unsafe { String.fromUtf8Unchecked(empty211) }
    failed += assertEq(s211a.size, 0, "T211_unchecked_empty_size")
    let bytes211: Array<UInt8> @local? = [0xE4u8, 0xB8u8, 0xADu8]
    let s211b: String @local! = unsafe { String.fromUtf8Unchecked(bytes211) }
    failed += assertEq(s211b.size, 3, "T211_unchecked_zhong_size")
    failed += assertB(s211b == "中", "T211_unchecked_zhong_value")
    failed += assertEq(s211b.toArray()[0], 0xE4u8, "T211_unchecked_zhong_bytes0")
    let bytes211l: Array<UInt8> @local! = [0x41u8, 0xC2u8, 0xA2u8]
    let s211c: String @local! = unsafe { String.fromUtf8Unchecked(bytes211l) }
    failed += assertB(s211c == "A¢", "T211_unchecked_QL_value")
    failed += assertEq(s211c.size, 3, "T211_unchecked_QL_size")


    // T202: Array-backed Collection<Rune> @local? → String @local!
    // （SDK local_mode-localmods-20260911-final 已实现 Collection 构造）
    let srcR202: Array<Rune> @local! = [r'A', r'\u{00A2}']
    let coll202: Collection<Rune> @local? = srcR202
    let s202: String @local! = String(coll202)
    failed += assertB(s202 == "A¢", "T202_collection_value")
    failed += assertEq(s202.size, 3, "T202_collection_size")
    // T201: QH Rune 数组直接入参（构造参数模式 @local? 接纳 heap widen）
    let heapRunes202: Array<Rune> = [r'x', r'y']
    let qr202: Array<Rune> @local? = heapRunes202
    let s202b: String @local! = String(qr202)
    failed += assertB(s202b == "xy", "T201_qh_runeArray")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
