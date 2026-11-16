// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args

func check(condition: Bool, message: String): Unit {
    if (!condition) { throw Exception(message) }
}

main(): Int64 {
    let source: Array<Int64> @local! = [10, 20, 30]
    let copy: Array<Int64> @local! = source.skip(0)
    copy[0] = 99
    check(source[0] == 10 && copy[0] == 99, "skip(0) must copy its source")
    source[1] = 77
    check(copy[1] == 20, "the copy must not observe later source writes")

    let slice: Array<Int64> @local! = source.slice(1, 2)
    let sliceCopy: Array<Int64> @local! = slice.skip(0)
    check(sliceCopy.size == 2 && sliceCopy[0] == 77 && sliceCopy[1] == 30, "slice offset")
    sliceCopy[0] = 88
    check(source[1] == 77, "skip(0) must copy an offset slice")

    let tail: Array<Int64> @local! = source.skip(1)
    check(tail.size == 2 && tail[0] == 77 && tail[1] == 30, "positive count")
    check(source.skip(3).isEmpty() && source.skip(4).isEmpty(), "exhausted source")
    let empty: Array<Int64> @local! = []
    check(empty.skip(0).isEmpty(), "empty array")
    var rejected = false
    try { let _: Array<Int64> @local! = source.skip(-1) }
    catch (_: IllegalArgumentException) { rejected = true }
    check(rejected, "negative count")
    println("local array skip copy passed")
    0
}
