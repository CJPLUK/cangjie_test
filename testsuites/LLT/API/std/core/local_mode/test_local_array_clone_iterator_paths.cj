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

func checkTexts(actual: Array<String> @local?, expected: Array<String>): Unit {
    check(actual.size == expected.size, "text array size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "text array contents") }
}

exclave func expectCloneError(source: Array<Int64> @local!, range: Range<Int64>): Unit {
    var caught = false
    try { let _: Array<Int64> @local! = source.clone(range) }
    catch (_: IndexOutOfBoundsException) { caught = true }
    check(caught, "clone must reject a range outside the logical view")
}

func checkClones(): Unit {
    let backing: Array<Int64> @local! = [90, 1, 2, 3, 4, 80]
    let view: Array<Int64> @local! = backing.slice(1, 4)
    let halfOpen: Array<Int64> @local! = view.clone(1..3)
    let closed: Array<Int64> @local! = view.clone(1..=2)
    let empty: Array<Int64> @local! = view.clone(4..4)
    checkContents(halfOpen, [2, 3])
    checkContents(closed, [2, 3])
    checkContents(empty, [])
    halfOpen[0] = 70
    closed[1] = 71
    checkContents(backing, [90, 1, 2, 3, 4, 80])
    view[1] = 72
    checkContents(halfOpen, [70, 3])
    checkContents(closed, [2, 71])

    expectCloneError(view, -1..1)
    expectCloneError(view, 0..5)
    expectCloneError(view, 3..2)
    checkContents(backing, [90, 1, 72, 3, 4, 80])

    let textBacking: Array<String> @local! = ["left", "one", "two", "three", "right"]
    let textView: Array<String> @local! = textBacking.slice(1, 3)
    let textCopy: Array<String> @local! = textView.clone(1..3)
    checkTexts(textCopy, ["two", "three"])
    textCopy[0] = "copy"
    checkTexts(textBacking, ["left", "one", "two", "three", "right"])
    textView[2] = "source"
    checkTexts(textCopy, ["copy", "three"])

    let shared: Array<String> @local? = textView
    let sharedCopy: Array<String> @local? = shared.clone()
    checkTexts(sharedCopy, ["one", "two", "source"])
    textView[0] = "changed"
    checkTexts(sharedCopy, ["one", "two", "source"])
}

exclave func checkOwnedInts(source: Array<Int64> @local!, expected: Array<Int64>): Unit {
    let iterator: Iterator<Int64> @local! = source.iterator()
    for (i in 0..expected.size) {
        let item: Option<Int64> @local! = iterator.next()
        match (item) {
            case Some(value) => check(value == expected[i], "owned iterator Int64 payload")
            case None => throw Exception("owned iterator ended early")
        }
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "owned iterator stays exhausted")
}

func checkSharedInts(source: Array<Int64> @local?, expected: Array<Int64>): Unit {
    let iterator: Iterator<Int64> @local? = source.iterator()
    for (i in 0..expected.size) {
        let item: Option<Int64> @local? = iterator.next()
        match (item) {
            case Some(value) => check(value == expected[i], "shared iterator Int64 payload")
            case None => throw Exception("shared iterator ended early")
        }
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "shared iterator stays exhausted")
}

exclave func checkOwnedTexts(source: Array<String> @local!, expected: Array<String>): Unit {
    let iterator: Iterator<String> @local! = source.iterator()
    for (i in 0..expected.size) {
        let item: Option<String> @local! = iterator.next()
        match (item) {
            case Some(value) => check(value == expected[i], "owned iterator String payload")
            case None => throw Exception("owned text iterator ended early")
        }
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "owned text iterator stays exhausted")
}

func checkSharedTexts(source: Array<String> @local?, expected: Array<String>): Unit {
    let iterator: Iterator<String> @local? = source.iterator()
    for (i in 0..expected.size) {
        let item: Option<String> @local? = iterator.next()
        match (item) {
            case Some(value) => check(value == expected[i], "shared iterator String payload")
            case None => throw Exception("shared text iterator ended early")
        }
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "shared text iterator stays exhausted")
}

func checkIterators(): Unit {
    let empty: Array<Int64> @local! = []
    let one: Array<Int64> @local! = [7]
    let backing: Array<Int64> @local! = [99, 1, 2, 3, 88]
    let view: Array<Int64> @local! = backing.slice(1, 3)
    checkOwnedInts(empty, [])
    checkSharedInts(empty, [])
    checkOwnedInts(one, [7])
    checkSharedInts(one, [7])
    checkOwnedInts(view, [1, 2, 3])
    checkSharedInts(view, [1, 2, 3])

    let emptyText: Array<String> @local! = []
    let oneText: Array<String> @local! = ["only"]
    let texts: Array<String> @local! = ["left", "first", "second", "last", "right"]
    let textView: Array<String> @local! = texts.slice(1, 3)
    checkOwnedTexts(emptyText, [])
    checkSharedTexts(emptyText, [])
    checkOwnedTexts(oneText, ["only"])
    checkSharedTexts(oneText, ["only"])
    checkOwnedTexts(textView, ["first", "second", "last"])
    checkSharedTexts(textView, ["first", "second", "last"])
}

main(): Int64 {
    checkClones()
    checkIterators()
    println("ALL PASSED")
    0
}
