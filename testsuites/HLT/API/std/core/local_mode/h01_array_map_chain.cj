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

func checkContents(actual: Array<Int64> @local?, expected: Array<Int64>): Unit {
    check(actual.size == expected.size, "chain array size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "chain array contents") }
}

main(): Int64 {
    let source: Array<Int64> @local! = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let mapped: Array<Int64> @local! = source.map({value => value * value})
    let filtered: Array<Int64> @local! = mapped.filter({value => value % 2 == 0})
    let result: Int64 @local! = filtered.fold(0, {sum, value => sum + value})
    checkContents(mapped, [1, 4, 9, 16, 25, 36, 49, 64, 81, 100])
    checkContents(filtered, [4, 16, 36, 64, 100])
    check(result == 220, "local map/filter/fold result")
    checkContents(source, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    println("ALL PASSED")
    0
}
