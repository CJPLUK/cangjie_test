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

func checkLargeStep(count: Int64): Unit {
    let backing: Array<Int64> @local! = [99, 1, 2, 3, 4, 88]
    let source: Array<Int64> @local! = backing.slice(1, 4)
    let result: Array<Int64> @local! = source.step(count)
    check(result.size == 1 && result[0] == 1, "a large positive step must retain the first element")
    for (i in 0..4) { check(source[i] == i + 1, "stepping must preserve its source") }
    check(backing[0] == 99 && backing[5] == 88, "stepping must preserve slice sentinels")
    let empty: Array<Int64> @local! = []
    let emptyResult: Array<Int64> @local! = empty.step(count)
    check(emptyResult.isEmpty(), "an empty array remains empty with a large step")
}

func checkHeapLargeStep(count: Int64): Unit {
    let backing = [99, 1, 2, 3, 4, 88]
    let source = backing.slice(1, 4)
    let result = source.step(count)
    check(result.size == 1 && result[0] == 1, "heap large step must retain the first element")
    for (i in 0..4) { check(source[i] == i + 1, "heap stepping preserves its source") }
    check(backing[0] == 99 && backing[5] == 88, "heap stepping preserves slice sentinels")
    check(Array<Int64>().step(count).isEmpty(), "empty heap array remains empty")
}

main(): Int64 {
    var failed = 0
    for (count in [5, Int64.Max - 3, Int64.Max - 2, Int64.Max]) {
        try { checkHeapLargeStep(count) }
        catch (e: Exception) { println("heap step=" + count.toString() + ": " + e.message); failed++ }
        try { checkLargeStep(count) }
        catch (e: Exception) { println("step=" + count.toString() + ": " + e.message); failed++ }
    }
    if (failed != 0) { return 1 }
    println("ALL PASSED")
    0
}
