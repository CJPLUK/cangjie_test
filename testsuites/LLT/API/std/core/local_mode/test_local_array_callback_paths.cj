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

class CallbackTrace {
    var count: Int64 = 0
    var order: Int64 = 0

    func record(index: Int64): Unit {
        count++
        order = order * 10 + index + 1
    }
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkContents(actual: Array<Int64> @local?, expected: Array<Int64>): Unit {
    check(actual.size == expected.size, "constructor result size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "constructor result contents") }
}

func negativeLength(): Int64 { -1 }

func checkOwnedCallbacks(): Unit {
    let zeroTrace = CallbackTrace()
    let empty: Array<Int64> @local! = Array<Int64>(0, {index =>
        zeroTrace.record(index)
        throw ArithmeticException("zero callback")
    }) @local!
    check(empty.size == 0 && zeroTrace.count == 0, "owned empty constructor must not call its initializer")

    let negativeTrace = CallbackTrace()
    var rejected = false
    try {
        let _ = Array<Int64>(negativeLength(), {index =>
            negativeTrace.record(index)
            index
        }) @local!
    } catch (_: NegativeArraySizeException) { rejected = true }
    check(rejected && negativeTrace.count == 0, "owned negative size must fail before the callback")

    let trace = CallbackTrace()
    let initialized: Array<Int64> @local! = Array<Int64>(3, {index =>
        trace.record(index)
        index + 10
    }) @local!
    checkContents(initialized, [10, 11, 12])
    check(trace.count == 3 && trace.order == 123, "owned initializer indices and count")

    let throwingTrace = CallbackTrace()
    var caught = false
    try {
        let _ = Array<Int64>(4, {index =>
            throwingTrace.record(index)
            if (index == 1) { throw ArithmeticException("owned constructor sentinel") }
            index
        }) @local!
    } catch (e: ArithmeticException) { caught = e.message == "owned constructor sentinel" }
    check(caught && throwingTrace.count == 2 && throwingTrace.order == 12,
        "owned initializer exception must stop at the throwing index")
}

func checkSharedCallbacks(): Unit {
    let zeroTrace = CallbackTrace()
    let empty: Array<Int64> @local? = Array<Int64>(0, {index =>
        zeroTrace.record(index)
        throw ArithmeticException("zero callback")
    }) @local?
    check(empty.size == 0 && zeroTrace.count == 0, "shared empty constructor must not call its initializer")

    let negativeTrace = CallbackTrace()
    var rejected = false
    try {
        let _ = Array<Int64>(negativeLength(), {index =>
            negativeTrace.record(index)
            index
        }) @local?
    } catch (_: NegativeArraySizeException) { rejected = true }
    check(rejected && negativeTrace.count == 0, "shared negative size must fail before the callback")

    let trace = CallbackTrace()
    let initialized: Array<Int64> @local? = Array<Int64>(3, {index =>
        trace.record(index)
        index + 20
    }) @local?
    checkContents(initialized, [20, 21, 22])
    check(trace.count == 3 && trace.order == 123, "shared initializer indices and count")

    let throwingTrace = CallbackTrace()
    var caught = false
    try {
        let _ = Array<Int64>(4, {index =>
            throwingTrace.record(index)
            if (index == 1) { throw ArithmeticException("shared constructor sentinel") }
            index
        }) @local?
    } catch (e: ArithmeticException) { caught = e.message == "shared constructor sentinel" }
    check(caught && throwingTrace.count == 2 && throwingTrace.order == 12,
        "shared initializer exception must stop at the throwing index")
}

exclave func ownedText(index: Int64): String @local! {
    if (index == 0) { "first" } else if (index == 1) { "middle" } else { "last" }
}

exclave func sharedText(index: Int64): String @local? {
    if (index == 0) { "first" } else if (index == 1) { "middle" } else { "last" }
}

func checkReferencePayloads(): Unit {
    let owned: Array<String> @local! = Array<String>(3, ownedText) @local!
    let shared: Array<String> @local? = Array<String>(3, sharedText) @local?
    check(owned.size == 3 && owned[0] == "first" && owned[1] == "middle" && owned[2] == "last",
        "owned initializer must preserve non-Copyable payloads")
    check(shared.size == 3 && shared[0] == "first" && shared[1] == "middle" && shared[2] == "last",
        "shared initializer must preserve non-Copyable payloads")
}

main(): Int64 {
    checkOwnedCallbacks()
    checkSharedCallbacks()
    checkReferencePayloads()
    println("ALL PASSED")
    0
}
