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

func check(condition: Bool, message: String): Unit {
    if (!condition) {
        println("CHECK FAILED: ${message}")
        throw Exception(message)
    }
}

func testArrayOverlap(): Unit {
    let data: Array<Int64> @local! = [1, 2, 3, 4, 5, 6]
    let view: Array<Int64> @local? = data.slice(1, 4)
    view[1..4] = view[0..3]
    check(view[0] == 2 && view[1] == 2 && view[2] == 3 && view[3] == 4,
        "overlapping assignment to the right must preserve the source")
    check(data[0] == 1 && data[5] == 6, "assignment must respect slice offsets")

    view[0..3] = view[1..4]
    check(view[0] == 2 && view[1] == 3 && view[2] == 4 && view[3] == 4,
        "overlapping assignment to the left must preserve the source")
    view[0..4] = view[0..4]
    view[2..2] = view[0..0]
    check(view[0] == 2 && view[1] == 3 && view[2] == 4 && view[3] == 4,
        "identical and empty assignments must preserve the array")

    let separate: Array<Int64> @local! = [8, 9]
    view[1..3] = separate
    check(view[0] == 2 && view[1] == 8 && view[2] == 9 && view[3] == 4,
        "non-overlapping assignment must copy the requested range")
}

main(): Int64 {
    testArrayOverlap()
    println("ALL PASSED")
    return 0
}
