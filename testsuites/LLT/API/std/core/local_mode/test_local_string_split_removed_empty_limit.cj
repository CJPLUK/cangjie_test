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

func checkSegments(actual: Array<String> @local?, expected: Array<String>, label: String): Unit {
    check(actual.size == expected.size, label)
    for (i in 0..expected.size) { check(actual[i] == expected[i], label) }
}

func checkSplit(text: String, separator: String, limit: Int64, expected: Array<String>): Unit {
    let heap = text.split(separator, limit, removeEmpty: true)
    checkSegments(heap, expected, "heap split must retain the expected nonempty segments")
    let localText: String @local! = String(text) @local!
    let localResult: Array<String> @local! = localText.split(separator, limit, removeEmpty: true)
    checkSegments(localResult, expected, "local split must retain the expected nonempty segments")
    check(localResult.size == heap.size, "split count must agree across modes")
    for (i in 0..heap.size) { check(localResult[i] == heap[i], "split contents must agree across modes") }
}

main(): Int64 {
    checkSplit(",A,,仓,", ",", 2, ["A", "仓"])
    checkSplit(",A,,仓,😀,", ",", 2, ["A", "仓,😀,"])
    checkSplit(",A,", ",", 1, [",A,"])
    checkSplit(",A,", ",", 2, ["A"])
    checkSplit(",,,", ",", 1, [])
    checkSplit(",,,", ",", 2, [])
    checkSplit("仓A仓仓B仓", "仓", 2, ["A", "B"])
    checkSplit("仓A仓仓B仓😀仓", "仓", 2, ["A", "B仓😀仓"])
    println("ALL PASSED")
    0
}
