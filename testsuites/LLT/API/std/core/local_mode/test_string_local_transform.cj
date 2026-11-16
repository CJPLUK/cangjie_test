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
// 覆盖设计项（LM-DOC-20260910）：T212/T213/T214/T215/T216/T217/T222。
// T223 红项（SPEC-CONFLICT）：闭环 :583-587 的 `static join(this @local!,...)` 带接收者
// 的静态声明无可调用路径，也不能由本文件的 T222 冒充交付；待规格作者修正文档。
// 设计编号命名空间：LM-DOC-20260910。

// 极值经运行时 helper 取得，避免常量求值提前失败
func overRepeatCount(): Int64 {
    Int64(UInt32.Max) / 2 + 1
}

func emptyMaxRepeatCount(): Int64 {
    Int64.Max
}

func maxRepeatCount(): Int64 {
    Int64(UInt32.Max)
}

main(): Int64 {
    var failed = 0

    // T212: clone/toArray/toRuneArray/rawData 完整序列（S201 fixture）
    let s212: String @local! = "A¢仓\u{1F600}\u{0000}"
    let c212: String @local! = s212.clone()
    failed += assertB(c212 == "A¢仓\u{1F600}\u{0000}", "T212_clone_value")
    failed += assertEq(c212.size, 11, "T212_clone_size")
    let arr212: Array<Byte> @local! = s212.toArray()
    failed += assertEq(arr212.size, 11, "T212_toArray_size")
    failed += assertEq(arr212[0], 0x41u8, "T212_toArray_0")
    failed += assertEq(arr212[10], 0x00u8, "T212_toArray_10")
    let runes212: Array<Rune> @local! = s212.toRuneArray()
    failed += assertEq(runes212.size, 5, "T212_toRuneArray_size")
    failed += assertB(runes212[1] == r'\u{00A2}', "T212_rune_1")
    let raw212: Array<Byte> @local! = unsafe { s212.rawData() }
    failed += assertEq(raw212.size, 11, "T212_rawData_size")
    failed += assertEq(raw212[3], 0xE4u8, "T212_rawData_3")
    failed += assertEq(raw212[6], 0xF0u8, "T212_rawData_6")

    // T213: concat 含 NUL/Unicode 与 empty identity
    let a213: String @local! = "A\u{0000}"
    let b213: String @local? = "仓\u{1F600}"
    let r213: String @local! = a213 + b213
    failed += assertB(r213 == "A\u{0000}仓\u{1F600}", "T213_concat_value")
    failed += assertEq(r213.size, 9, "T213_concat_size")
    let e213: String @local! = ""
    failed += assertB(e213 + a213 == "A\u{0000}", "T213_empty_left_identity")
    failed += assertB(a213 + e213 == "A\u{0000}", "T213_empty_right_identity")

    // T214: repeat ¢×3、0、负、超限；空串组合
    let cent214: String @local! = "¢"
    let r214a: String @local! = cent214 * 3
    failed += assertB(r214a == "¢¢¢", "T214_repeat_3")
    failed += assertEq(r214a.size, 6, "T214_repeat_3_size")
    let r214b: String @local! = cent214 * 0
    failed += assertEq(r214b.size, 0, "T214_repeat_0")
    let negN: Int64 = -1
    try {
        let _ = cent214 * negN
        failed += 1
        println("FAIL: T214_repeat_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    let overN: Int64 = overRepeatCount()
    try {
        let _ = cent214 * overN
        failed += 1
        println("FAIL: T214_repeat_over — expected allocation guard IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    let empty214: String @local! = ""
    let emptyMaxN: Int64 = emptyMaxRepeatCount()
    let r214c: String @local! = empty214 * emptyMaxN
    failed += assertEq(r214c.size, 0, "T214_repeat_empty_huge")
    try {
        let _ = empty214 * negN
        failed += 1
        println("FAIL: T214_repeat_empty_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    // T215: replace 空接收者/空 old/无匹配/多 match/NUL
    let e215: String @local! = ""
    failed += assertB(e215.replace("", "X") == "X", "T215_emptyReceiver_emptyOld")
    failed += assertB(e215.replace("a", "X") == "", "T215_emptyReceiver_noOld")
    let c215: String @local! = "A仓"
    failed += assertB(c215.replace("", "-") == "-A-仓-", "T215_emptyOld_runeInsert")
    let nul215: String @local! = "a\u{0000}a"
    failed += assertB(nul215.replace("\u{0000}", "X") == "aXa", "T215_nul_match")
    let nm215: String @local! = "abc"
    failed += assertB(nm215.replace("zz", "X") == "abc", "T215_noMatch_unchanged")
    let multi215: String @local! = "cangjie仓颉cangjie仓颉"
    failed += assertB(multi215.replace("jie仓颉", "Jie") == "cangJiecangJie", "T215_multi_exact")

    // T216: ASCII 大小写边界与非 ASCII 不变
    let s216: String @local! = "Az@[`a{éÉ仓\u{1F600}"
    let l216: String @local! = s216.toAsciiLower()
    failed += assertB(l216 == "az@[`a{éÉ仓\u{1F600}", "T216_lower_bytes")
    let u216: String @local! = s216.toAsciiUpper()
    failed += assertB(u216 == "AZ@[`A{éÉ仓\u{1F600}", "T216_upper_bytes")
    let t216a: String @local! = "hELLO-world_ABC éCLAIR"
    let ti216: String @local! = t216a.toAsciiTitle()
    failed += assertB(ti216 == "Hello-World_Abc éClair", "T216_title_ascii")
    let t216b: String @local! = "e\u{0301}ABC"
    let ti216b: String @local! = t216b.toAsciiTitle()
    failed += assertB(ti216b == "E\u{0301}Abc", "T216_title_combining")

    // T217: trimAscii/Start/End 与 removePrefix/Suffix；返回绑定 String @local!
    let t217a: String @local! = "\t 仓 \n"
    let r217a: String @local! = t217a.trimAscii()
    failed += assertB(r217a == "仓", "T217_trimAscii")
    let r217b: String @local! = t217a.trimAsciiStart()
    failed += assertB(r217b == "仓 \n", "T217_trimStart")
    let r217c: String @local! = t217a.trimAsciiEnd()
    failed += assertB(r217c == "\t 仓", "T217_trimEnd")
    let e217: String @local! = ""
    failed += assertB(e217.trimAscii() == "", "T217_trim_empty")
    let ws217: String @local! = " \t\n\r"
    failed += assertB(ws217.trimAscii() == "", "T217_trim_allAsciiWs")
    failed += assertB(ws217.trimAsciiStart() == "", "T217_trimStart_allAsciiWs")
    failed += assertB(ws217.trimAsciiEnd() == "", "T217_trimEnd_allAsciiWs")
    let nbsp217: String @local! = "\u{00A0}A\u{00A0}"
    failed += assertB(nbsp217.trimAscii() == "\u{00A0}A\u{00A0}", "T217_nbsp_notAsciiWs")
    // remove 命中/未命中/空模式
    let rm217: String @local! = "仓abc\u{1F600}"
    let q217a: String @local! = rm217.removePrefix("仓")
    failed += assertB(q217a == "abc\u{1F600}", "T217_removePrefix_hit")
    let q217b: String @local! = rm217.removeSuffix("\u{1F600}")
    failed += assertB(q217b == "仓abc", "T217_removeSuffix_hit")
    failed += assertB(rm217.removePrefix("X") == "仓abc\u{1F600}", "T217_removePrefix_miss")
    failed += assertB(rm217.removeSuffix("X") == "仓abc\u{1F600}", "T217_removeSuffix_miss")
    failed += assertB(rm217.removePrefix("") == "仓abc\u{1F600}", "T217_removePrefix_empty")
    failed += assertB(rm217.removeSuffix("") == "仓abc\u{1F600}", "T217_removeSuffix_empty")

    // T222: static join 空/单/多元素；@local! 版无 delimiter 默认值（URL 文档 §15，
    // 2026-09-28 契约翻转），原"省略 delimiter"的调用改为显式传 String.empty。
    let emptyArr222: Array<String> @local! = []
    let j222a: String @local! = String.join(emptyArr222, delimiter: String.empty)
    failed += assertEq(j222a.size, 0, "T222_join_empty_defaultDelim")
    let oneBlank222: Array<String> @local! = [""]
    let j222b: String @local! = String.join(oneBlank222, delimiter: String.empty)
    failed += assertEq(j222b.size, 0, "T222_join_singleBlank")
    let oneA222: Array<String> @local! = ["A"]
    let j222c: String @local! = String.join(oneA222, delimiter: "-")
    failed += assertB(j222c == "A", "T222_join_single_explicitDelim")
    let two222: Array<String> @local! = ["A", "仓"]
    let j222d: String @local! = String.join(two222, delimiter: String.empty)
    failed += assertB(j222d == "A仓", "T222_join_defaultDelim")
    let j222e: String @local! = String.join(two222, delimiter: "\u{0000}")
    failed += assertB(j222e == "A\u{0000}仓", "T222_join_nulDelim")
    failed += assertEq(j222e.size, 5, "T222_join_nulDelim_size")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
