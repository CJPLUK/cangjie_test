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

func checkHeapAppend(capacity: Int64): Unit {
    let text: String @local! = "abcd"
    let shared: String @local? = text
    let empty: String @local? = ""
    let builder = StringBuilder(capacity)
    builder.append(text)
    check(builder.size == 4 && builder.toString() == "abcd", "first local append")
    builder.append(empty)
    check(builder.size == 4 && builder.toString() == "abcd", "empty append preserves content")
    builder.append(shared)
    check(builder.size == 8 && builder.toString() == "abcdabcd", "second local append after an empty value")
}

func checkLocalGrowth(): Unit {
    let text: String @local! = "abcd"
    let builder: StringBuilder @local! = StringBuilder() @local!
    for (_ in 0..9) { builder.append(text) }
    let view: StringBuilder @local? = builder
    let snapshot: String @local! = view.toString()
    check(snapshot == text * 9 && snapshot.size == 36, "local builder growth")
    builder.append(text)
    let result: String @local! = view.toString()
    check(result == text * 10 && snapshot == text * 9, "local snapshot remains independent")
}

main(): Int64 {
    checkLocalGrowth()
    var failed = 0
    for (capacity in [1, 4, 8, 64]) {
        try { checkHeapAppend(capacity) }
        catch (e: Exception) {
            println(e.message)
            failed++
        }
    }
    if (failed != 0) { return 1 }
    println("ALL PASSED")
    0
}
