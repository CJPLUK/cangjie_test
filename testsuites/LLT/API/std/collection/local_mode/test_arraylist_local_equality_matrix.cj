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

import std.collection.*

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkEqual<T>(left: ArrayList<T> @local?, right: ArrayList<T> @local?, equal: Bool): Unit
    where T <: Equatable<T> {
    check((left == right) == equal, "local list equality")
    check((right == left) == equal, "local list equality symmetry")
    check((left != right) == !equal, "local list inequality complements equality")
}

main(): Int64 {
    let empty: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    let otherEmpty: ArrayList<Int64> @local! = ArrayList<Int64>(0) @local!
    checkEqual(empty, otherEmpty, true)
    let first: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    first.add(1); first.add(2)
    let same: ArrayList<Int64> @local! = ArrayList<Int64>(2) @local!
    same.add(1); same.add(2)
    let reversed: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    reversed.add(2); reversed.add(1)
    let shorter: ArrayList<Int64> @local! = ArrayList<Int64>(16) @local!
    shorter.add(1)
    checkEqual(first, first, true)
    checkEqual(first, same, true)
    checkEqual(first, reversed, false)
    checkEqual(first, shorter, false)
    checkEqual(first, empty, false)
    let heap = ArrayList<Int64>([1, 2])
    checkEqual(first, heap, true)
    same[1] = 3
    checkEqual(first, same, false)

    let words: ArrayList<String> @local! = ArrayList<String>() @local!
    words.add("a"); words.add("仓")
    let sameWords: ArrayList<String> @local! = ArrayList<String>() @local!
    sameWords.add("a"); sameWords.add("仓")
    checkEqual(words, sameWords, true)
    sameWords[1] = "b"
    checkEqual(words, sameWords, false)
    println("ALL PASSED")
    0
}
