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

func negativeLength(): Int64 { -1 }

func checkBasicConstructors(): Unit {
    let empty: Array<Int64> @local! = Array<Int64>() @local!
    let repeated: Array<Int64> @local! = Array<Int64>(3, repeat: 7) @local!
    let repeatedEmpty: Array<Int64> @local! = Array<Int64>(0, repeat: 7) @local!
    checkContents(empty, [])
    checkContents(repeated, [7, 7, 7])
    checkContents(repeatedEmpty, [])
    var caught = false
    try { let _ = Array<Int64>(negativeLength(), repeat: 7) @local! }
    catch (_: NegativeArraySizeException) { caught = true }
    check(caught, "negative repeat constructor size")
}

exclave func checkOwnedSliceErrors(source: Array<Int64> @local!): Unit {
    for ((start, size) in [(-1, 1), (0, -1), (3, 2), (Int64.Max, 1), (1, Int64.Max)]) {
        var caught = false
        try { let _: Array<Int64> @local! = source.slice(start, size) }
        catch (_: IndexOutOfBoundsException) { caught = true }
        check(caught, "owned slice must reject invalid bounds without arithmetic overflow")
        checkContents(source, [0, 1, 2, 3])
    }
    let empty: Array<Int64> @local! = source.slice(source.size, 0)
    check(empty.size == 0, "owned slice at the end with zero length is empty")
}

func checkSharedSliceErrors(source: Array<Int64> @local?): Unit {
    for ((start, size) in [(-1, 1), (0, -1), (3, 2), (Int64.Max, 1), (1, Int64.Max)]) {
        var caught = false
        try { let _: Array<Int64> @local? = source.slice(start, size) }
        catch (_: IndexOutOfBoundsException) { caught = true }
        check(caught, "shared slice must reject invalid bounds without arithmetic overflow")
        checkContents(source, [0, 1, 2, 3])
    }
    let empty: Array<Int64> @local? = source.slice(source.size, 0)
    check(empty.size == 0, "shared slice at the end with zero length is empty")
}

func checkSlices(): Unit {
    let backing: Array<Int64> @local! = [0, 1, 2, 3]
    let owned: Array<Int64> @local! = backing.slice(1, 2)
    let sharedSource: Array<Int64> @local? = backing
    let shared: Array<Int64> @local? = sharedSource.slice(1, 2)
    checkContents(owned, [1, 2])
    checkContents(shared, [1, 2])
    owned[0] = 7
    checkContents(backing, [0, 7, 2, 3])
    checkContents(shared, [7, 2])
    shared[1] = 8
    checkContents(backing, [0, 7, 8, 3])
    checkContents(owned, [7, 8])

    let source: Array<Int64> @local! = [0, 1, 2, 3]
    checkOwnedSliceErrors(source)
    checkSharedSliceErrors(source)
    let empty: Array<Int64> @local! = []
    let emptyOwned: Array<Int64> @local! = empty.slice(0, 0)
    let emptySharedSource: Array<Int64> @local? = empty
    let emptyShared: Array<Int64> @local? = emptySharedSource.slice(0, 0)
    check(emptyOwned.size == 0 && emptyShared.size == 0, "empty source slice")
}

func checkWholeClones(): Unit {
    let source: Array<Int64> @local! = [1, 2, 3]
    let copy: Array<Int64> @local! = source.clone()
    checkContents(copy, [1, 2, 3])
    copy[0] = 9
    checkContents(source, [1, 2, 3])
    source[1] = 8
    checkContents(copy, [9, 2, 3])
    let empty: Array<Int64> @local! = []
    let emptyCopy: Array<Int64> @local! = empty.clone()
    checkContents(emptyCopy, [])
}

main(): Int64 {
    checkBasicConstructors()
    checkSlices()
    checkWholeClones()
    println("ALL PASSED")
    0
}
