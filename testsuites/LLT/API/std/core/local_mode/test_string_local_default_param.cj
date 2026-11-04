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
// 覆盖设计项（LM-DOC-20260910）：T218/T219（split 精确元素）、T220（pad 矩阵）。
// T221（local 实参传 plain String 参数的编译负例）见 test_string_local_neg_plain_param_*.cj。
// 设计编号命名空间：LM-DOC-20260910。

// 极值经运行时 helper 取得，避免常量求值提前失败
func hugeWidth(): Int64 {
    Int64(UInt32.Max) + 1
}

func maxPaddingWidth(): Int64 {
    Int64(UInt32.Max)
}

main(): Int64 {
    var failed = 0

    // T218: ",A,,仓," sep=','，省略/default false 与 true 精确元素
    let recv218: String @local! = ",A,,仓,"
    let p218a: Array<String> @local! = recv218.split(",")
    failed += assertEq(p218a.size, 5, "T218_default_size")
    failed += assertB(p218a[0] == "", "T218_default_0_empty")
    failed += assertB(p218a[1] == "A", "T218_default_1")
    failed += assertB(p218a[2] == "", "T218_default_2_empty")
    failed += assertB(p218a[3] == "仓", "T218_default_3")
    failed += assertB(p218a[4] == "", "T218_default_4_empty")
    let p218b: Array<String> @local! = recv218.split(",", removeEmpty: true)
    failed += assertEq(p218b.size, 2, "T218_removeEmpty_size")
    failed += assertB(p218b[0] == "A", "T218_removeEmpty_0")
    failed += assertB(p218b[1] == "仓", "T218_removeEmpty_1")
    // T218: empty receiver
    let empty218: String @local! = ""
    let p218c: Array<String> @local! = empty218.split(",")
    failed += assertEq(p218c.size, 0, "T218_empty_receiver_size")
    // T218: empty separator 按 scalar 拆分（不按 grapheme）
    let uni218: String @local! = "A¢仓\u{1F600}"
    let p218d: Array<String> @local! = uni218.split("")
    failed += assertEq(p218d.size, 4, "T218_emptySep_size")
    failed += assertB(p218d[0] == "A", "T218_emptySep_0")
    failed += assertB(p218d[1] == "¢", "T218_emptySep_1")
    failed += assertB(p218d[2] == "仓", "T218_emptySep_2")
    failed += assertB(p218d[3] == "\u{1F600}", "T218_emptySep_3")

    // T219: maxSplits 0/1/2/-1 与组合序列
    let recv219: String @local! = "A,仓,\u{1F600}"
    let p219a: Array<String> @local! = recv219.split(",", 0)
    failed += assertEq(p219a.size, 0, "T219_max0_size")
    let p219b: Array<String> @local! = recv219.split(",", 1)
    failed += assertEq(p219b.size, 1, "T219_max1_size")
    failed += assertB(p219b[0] == "A,仓,\u{1F600}", "T219_max1_whole")
    let p219c: Array<String> @local! = recv219.split(",", 2)
    failed += assertEq(p219c.size, 2, "T219_max2_size")
    failed += assertB(p219c[0] == "A", "T219_max2_0")
    failed += assertB(p219c[1] == "仓,\u{1F600}", "T219_max2_1")
    let p219d: Array<String> @local! = recv219.split(",", -1)
    failed += assertEq(p219d.size, 3, "T219_maxNeg_unlimited_size")
    failed += assertB(p219d[0] == "A", "T219_maxNeg_0")
    failed += assertB(p219d[1] == "仓", "T219_maxNeg_1")
    failed += assertB(p219d[2] == "\u{1F600}", "T219_maxNeg_2")
    // T219: 组合序列拆分（不是 grapheme）
    let comb219: String @local! = "e\u{0301}X"
    let p219e: Array<String> @local! = comb219.split("", 2)
    failed += assertEq(p219e.size, 2, "T219_comb_max2_size")
    failed += assertB(p219e[0] == "e", "T219_comb_max2_0")
    failed += assertB(p219e[1] == "\u{0301}X", "T219_comb_max2_1")

    // T220: padStart/padEnd 矩阵
    let a220: String @local! = "A"
    // 默认 padding（空格）width3 → 两空格
    let d220a: String @local! = a220.padStart(3)
    failed += assertB(d220a == "  A", "T220_padStart_default")
    let d220b: String @local! = a220.padEnd(3)
    failed += assertB(d220b == "A  ", "T220_padEnd_default")
    // heap 变量 padding=仓，width4 → 仓A / A仓（按 UTF-8 bytes 计宽）
    let padHeap: String = "仓"
    let h220a: String @local! = a220.padStart(4, padding: padHeap)
    failed += assertB(h220a == "仓A", "T220_padStart_heap_w4")
    let h220b: String @local! = a220.padEnd(4, padding: padHeap)
    failed += assertB(h220b == "A仓", "T220_padEnd_heap_w4")
    // width5 → 完整 padding 重复：仓仓A / A仓仓
    let h220c: String @local! = a220.padStart(5, padding: padHeap)
    failed += assertB(h220c == "仓仓A", "T220_padStart_heap_w5")
    let h220d: String @local! = a220.padEnd(5, padding: padHeap)
    failed += assertB(h220d == "A仓仓", "T220_padEnd_heap_w5")
    // width0 → no-op；width1 < size2 → no-op
    let z220: String @local! = a220.padStart(0)
    failed += assertB(z220 == "A", "T220_padStart_w0_noop")
    let ab220: String @local! = "AB"
    let s220b: String @local! = ab220.padStart(1)
    failed += assertB(s220b == "AB", "T220_padStart_w1_lt_size_noop")
    let s220c: String @local! = ab220.padEnd(1)
    failed += assertB(s220c == "AB", "T220_padEnd_w1_lt_size_noop")
    // 负 width → IllegalArgumentException（分配前拒绝）
    let negW: Int64 = -1
    try {
        let _ = a220.padStart(negW)
        failed += 1
        println("FAIL: T220_padStart_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = a220.padEnd(negW)
        failed += 1
        println("FAIL: T220_padEnd_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    // 需填充且 padding 为空 → IllegalArgumentException
    let emptyPad: String = ""
    try {
        let _ = a220.padStart(4, padding: emptyPad)
        failed += 1
        println("FAIL: T220_padStart_emptyPadding — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = a220.padEnd(4, padding: emptyPad)
        failed += 1
        println("FAIL: T220_padEnd_emptyPadding — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    // 等宽 no-op 时 empty padding 不触发（仅在需要填充时求值路径外）
    // width=UInt32.Max+1 → width 超限，分配前拒绝
    let overW: Int64 = hugeWidth()
    try {
        let _ = a220.padStart(overW)
        failed += 1
        println("FAIL: T220_padStart_width_overflow — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = a220.padEnd(overW)
        failed += 1
        println("FAIL: T220_padEnd_width_overflow — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    // AA(2B)+仓(3B)=5B, width=UInt32.Max → 舍入后 bytes 超限，分配前拒绝
    let maxW: Int64 = maxPaddingWidth()
    let aa220: String @local! = "AA"
    try {
        let _ = aa220.padStart(maxW, padding: padHeap)
        failed += 1
        println("FAIL: T220_padStart_bytes_overflow — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = aa220.padEnd(maxW, padding: padHeap)
        failed += 1
        println("FAIL: T220_padEnd_bytes_overflow — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
