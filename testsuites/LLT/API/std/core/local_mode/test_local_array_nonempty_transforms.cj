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

class TransformTrace {
    var count: Int64 = 0
    var order: Int64 = 0
    var failAt: Int64 = -1

    func reset(): Unit { reset(-1) }

    func reset(failAt: Int64): Unit {
        count = 0
        order = 0
        this.failAt = failAt
    }

    func record(value: Int64): Unit {
        count++
        order = order * 10 + value
        if (value == failAt) { throw ArithmeticException("transform sentinel") }
    }
}

let calls = TransformTrace()

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkContents(actual: Array<Int64> @local?, expected: Array<Int64>): Unit {
    check(actual.size == expected.size, "transformed array size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "transformed array contents") }
}

func checkTexts(actual: Array<String> @local?, expected: Array<String>): Unit {
    check(actual.size == expected.size, "transformed text array size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "transformed text array contents") }
}

func checkTrace(count: Int64, order: Int64): Unit {
    check(calls.count == count && calls.order == order, "callback order and count")
}

func mapped(value: Int64 @local!): Int64 @local! {
    calls.record(value)
    value * 10
}

exclave func mappedText(value: Int64 @local!): String @local! {
    calls.record(value)
    if (value == 1) { "one" } else if (value == 2) { "two" }
    else if (value == 3) { "three" } else { "four" }
}

func even(value: Int64 @local?): Bool {
    calls.record(value)
    value % 2 == 0
}

func keepAll(value: Int64 @local?): Bool {
    calls.record(value)
    true
}

func dropAll(value: Int64 @local?): Bool {
    calls.record(value)
    false
}

exclave func expanded(value: Int64 @local!): Array<Int64> @local! {
    calls.record(value)
    if (value == 2) {
        Array<Int64>() @local!
    } else {
        let result: Array<Int64> @local! = [value, value * 10]
        result
    }
}

exclave func emptyExpansion(value: Int64 @local!): Array<Int64> @local! {
    calls.record(value)
    Array<Int64>() @local!
}

exclave func selected(value: Int64 @local!): Option<String> @local! {
    calls.record(value)
    if (value == 1) { Some<String>("one") }
    else if (value == 3) { Some<String>("three") }
    else { None<String> }
}

exclave func discard(value: Int64 @local!): Option<String> @local! {
    calls.record(value)
    None<String>
}

func checkResults(): Unit {
    let backing: Array<Int64> @local! = [99, 1, 2, 3, 4, 88]
    let source: Array<Int64> @local! = backing.slice(1, 4)

    calls.reset()
    let mapResult: Array<Int64> @local! = source.map(mapped)
    checkContents(mapResult, [10, 20, 30, 40])
    checkTrace(4, 1234)
    mapResult[0] = 77
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset()
    let textResult: Array<String> @local! = source.map(mappedText)
    checkTexts(textResult, ["one", "two", "three", "four"])
    checkTrace(4, 1234)

    calls.reset()
    let filtered: Array<Int64> @local! = source.filter(even)
    checkContents(filtered, [2, 4])
    checkTrace(4, 1234)
    filtered[0] = 77
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset()
    let all: Array<Int64> @local! = source.filter(keepAll)
    checkContents(all, [1, 2, 3, 4])
    checkTrace(4, 1234)
    all[0] = 77
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset()
    let none: Array<Int64> @local! = source.filter(dropAll)
    checkContents(none, [])
    checkTrace(4, 1234)

    calls.reset()
    let flattened: Array<Int64> @local! = source.flatMap(expanded)
    checkContents(flattened, [1, 10, 3, 30, 4, 40])
    checkTrace(4, 1234)
    flattened[0] = 77
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset()
    let flatEmpty: Array<Int64> @local! = source.flatMap(emptyExpansion)
    checkContents(flatEmpty, [])
    checkTrace(4, 1234)

    calls.reset()
    let selectedResult: Array<String> @local! = source.filterMap(selected)
    checkTexts(selectedResult, ["one", "three"])
    checkTrace(4, 1234)
    selectedResult[0] = "changed"
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset()
    let discarded: Array<String> @local! = source.filterMap(discard)
    checkTexts(discarded, [])
    checkTrace(4, 1234)
}

func checkExceptions(): Unit {
    let backing: Array<Int64> @local! = [99, 1, 2, 3, 4, 88]
    let source: Array<Int64> @local! = backing.slice(1, 4)
    calls.reset(3)
    var caught = false
    try { let _: Array<Int64> @local! = source.map(mapped) }
    catch (e: ArithmeticException) { caught = e.message == "transform sentinel" }
    check(caught, "map must propagate the callback exception")
    checkTrace(3, 123)
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset(3)
    caught = false
    try { let _: Array<Int64> @local! = source.filter(even) }
    catch (e: ArithmeticException) { caught = e.message == "transform sentinel" }
    check(caught, "filter must propagate the callback exception")
    checkTrace(3, 123)
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset(3)
    caught = false
    try { let _: Array<Int64> @local! = source.flatMap(expanded) }
    catch (e: ArithmeticException) { caught = e.message == "transform sentinel" }
    check(caught, "flatMap must propagate the callback exception")
    checkTrace(3, 123)
    checkContents(backing, [99, 1, 2, 3, 4, 88])

    calls.reset(3)
    caught = false
    try { let _: Array<String> @local! = source.filterMap(selected) }
    catch (e: ArithmeticException) { caught = e.message == "transform sentinel" }
    check(caught, "filterMap must propagate the callback exception")
    checkTrace(3, 123)
    checkContents(backing, [99, 1, 2, 3, 4, 88])
}

func checkStepLimits(): Unit {
    let backing: Array<Int64> @local! = [99, 1, 2, 3, 4, 88]
    let source: Array<Int64> @local! = backing.slice(1, 4)
    let every: Array<Int64> @local! = source.step(1)
    let alternate: Array<Int64> @local! = source.step(2)
    let beyond: Array<Int64> @local! = source.step(5)
    checkContents(every, [1, 2, 3, 4])
    checkContents(alternate, [1, 3])
    checkContents(beyond, [1])
    let separated: Array<Int64> @local! = source.intersperse(0)
    checkContents(separated, [1, 0, 2, 0, 3, 0, 4])
    checkContents(backing, [99, 1, 2, 3, 4, 88])
}

main(): Int64 {
    checkResults()
    checkExceptions()
    checkStepLimits()
    println("ALL PASSED")
    0
}
