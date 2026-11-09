/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkSegments(actual: Array<String> @local?, expected: Array<String>): Unit {
    check(actual.size == expected.size, "split segment count")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "split segment contents") }
}

exclave func checkSplit(text: String @local!, separator: String @local?, limit: Int64,
    removeEmpty: Bool, expected: Array<String>): Unit {
    let actual: Array<String> @local! = text.split(separator, limit, removeEmpty: removeEmpty)
    checkSegments(actual, expected)
}

func checkEmptySegments(): Unit {
    checkSplit(",A,,仓,", ",", 0, false, [])
    checkSplit(",A,,仓,", ",", 0, true, [])
    checkSplit(",A,,仓,", ",", 1, false, [",A,,仓,"])
    checkSplit(",A,,仓,", ",", 1, true, [",A,,仓,"])
    checkSplit(",A,,仓,", ",", -1, false, ["", "A", "", "仓", ""])
    checkSplit(",A,,仓,", ",", -1, true, ["A", "仓"])
    checkSplit(",A,,仓,", ",", 8, false, ["", "A", "", "仓", ""])
    checkSplit(",A,,仓,", ",", 8, true, ["A", "仓"])
    checkSplit("仓仓", "仓", -1, false, ["", "", ""])
    checkSplit("仓仓", "仓", -1, true, [])
    checkSplit("", ",", -1, false, [])
    checkSplit("", ",", 2, true, [])
}

func checkSeparatorShapes(): Unit {
    checkSplit("A,仓,😀", ",", 2, true, ["A", "仓,😀"])
    checkSplit("<>A<><>仓<>", "<>", -1, false, ["", "A", "", "仓", ""])
    checkSplit("<>A<><>仓<>", "<>", -1, true, ["A", "仓"])
    checkSplit("A¢", "absent", 2, false, ["A¢"])
    checkSplit("A¢", "absent", 2, true, ["A¢"])
    checkSplit("e\u{0301}😀", "", 2, false, ["e", "\u{0301}😀"])
    checkSplit("e\u{0301}😀", "", 2, true, ["e", "\u{0301}😀"])
    checkSplit("e\u{0301}😀", "", 8, true, ["e", "\u{0301}", "😀"])

    let backing: String @local! = "!A<>仓<>😀?"
    let text: String @local! = backing[1..13]
    let separatorBacking: String @local! = "?<>!"
    let separator: String @local? = separatorBacking[1..3]
    checkSplit(text, separator, 2, true, ["A", "仓<>😀"])
    checkSplit(text, separator, -1, false, ["A", "仓", "😀"])
}

main(): Int64 {
    checkEmptySegments()
    checkSeparatorShapes()
    println("ALL PASSED")
    0
}
