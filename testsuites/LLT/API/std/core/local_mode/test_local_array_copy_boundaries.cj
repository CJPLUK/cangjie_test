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
    check(actual.size == expected.size, "array size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "array contents") }
}

func checkSharedErrors(source: Array<Int64> @local?, target: Array<Int64> @local?): Unit {
    source.copyTo(target, -1, Int64.Max, 0)
    checkContents(target, [9, 9, 9, 9])
    var illegal = false
    try { source.copyTo(target, 0, 0, -1) }
    catch (e: IllegalArgumentException) {
        check(e.message == "Invalid argument 'copyLen': expected a non-negative value, got '-1'.",
            "negative copy length diagnostic")
        illegal = true
    }
    check(illegal, "negative copy length")
    let invalid = [(-1, 0, 1), (0, -1, 1), (source.size, 0, 1),
        (0, target.size, 1), (2, 0, 2), (0, 3, 2), (0, 0, Int64.Max)]
    for ((src, dst, size) in invalid) {
        var caught = false
        try { source.copyTo(target, src, dst, size) }
        catch (_: IndexOutOfBoundsException) { caught = true }
        check(caught, "shared copy bounds")
        checkContents(target, [9, 9, 9, 9])
    }
}

func checkOwnedErrors(source: Array<Int64> @local!, target: Array<Int64> @local!): Unit {
    exclave {
        source.copyTo(target, -1, Int64.Max, 0)
        var illegal = false
        try { source.copyTo(target, 0, 0, -1) }
        catch (e: IllegalArgumentException) {
            check(e.message == "Invalid argument 'copyLen': expected a non-negative value, got '-1'.",
                "negative copy length diagnostic")
            illegal = true
        }
        check(illegal, "owned negative copy length")
        for ((src, dst, size) in [(-1, 0, 1), (0, -1, 1), (3, 0, 1),
            (0, 4, 1), (2, 0, 2), (0, 3, 2)]) {
            var caught = false
            try { source.copyTo(target, src, dst, size) }
            catch (_: IndexOutOfBoundsException) { caught = true }
            check(caught, "owned copy bounds")
            checkContents(target, [9, 9, 9, 9])
        }
    }
}

func checkOffsetsAndOverlap(): Unit {
    let backing: Array<Int64> @local! = [0, 1, 2, 3, 4, 5, 6, 7]
    let source: Array<Int64> @local? = backing.slice(1, 5)
    let target: Array<Int64> @local? = backing.slice(2, 5)
    source.copyTo(target, 0, 0, 5)
    checkContents(backing, [0, 1, 1, 2, 3, 4, 5, 7])
    target.copyTo(source, 0, 0, 5)
    checkContents(backing, [0, 1, 2, 3, 4, 5, 5, 7])
    target.copyTo(target, 1, 1, 3)
    checkContents(backing, [0, 1, 2, 3, 4, 5, 5, 7])
}

func checkRangeFailures(): Unit {
    let data: Array<Int64> @local! = [1, 2, 3, 4]
    let view: Array<Int64> @local? = data
    let one: Array<Int64> @local? = [7]
    var caught = false
    try { view[0..2 : 2] = one }
    catch (_: IllegalArgumentException) { caught = true }
    check(caught, "range step")
    checkContents(view, [1, 2, 3, 4])
    caught = false
    try { view[1..3] = one }
    catch (_: IllegalArgumentException) { caught = true }
    check(caught, "range length mismatch")
    checkContents(view, [1, 2, 3, 4])
    view[1..=2] = [7, 8]
    view[4..4] = []
    checkContents(view, [1, 7, 8, 4])
}

main(): Int64 {
    let source: Array<Int64> @local! = [1, 2, 3]
    let sharedTarget: Array<Int64> @local! = [9, 9, 9, 9]
    checkSharedErrors(source, sharedTarget)
    let ownedTarget: Array<Int64> @local! = [9, 9, 9, 9]
    checkOwnedErrors(source, ownedTarget)
    checkOffsetsAndOverlap()
    checkRangeFailures()
    println("ALL PASSED")
    0
}
