/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// BLOCKED-PAYLOAD: T401 full String.lines() returns corrupted String Option payload on this SDK
//   (C7); its doc-correct a,b,None assertions are retained below. T402's String @local? lines()
//   overload is also absent in the 0907 SDK. T405's public ArrayList mutation is isolated in
//   test_iterable_iterator_arraylist_mutation_blocked.cj for the local write barrier.
//   Restore EXEC after the corresponding runtime/stdlib blockers are fixed.
// UPDATE 2026-09-11: SDK local_mode-localmods-20260911-final 已修复本文件原阻塞器，恢复 EXEC（原阻塞记录见下）。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.core.*

class T400OriginalIterator <: Iterator<String> {
    private let values: Array<String>
    private var index: Int64 = 0

    init() {
        values = ["a", "b"]
    }

    public func next(): Option<String> {
        if (index < values.size) {
            let value = values[index]
            index += 1
            Some(value)
        } else {
            None
        }
    }
}

class T400OriginalIterable <: Iterable<String> {
    public func iterator(): Iterator<String> {
        T400OriginalIterator()
    }
}

// T403 fixture: only the original iterator() exists; local interface overloads
// must use Iterable's default body and throw IllegalStateException (doc §1).
class T403OriginalOnlyIterable <: Iterable<String> {
    public func iterator(): Iterator<String> {
        T400OriginalIterator()
    }
}

// T404 fixture: only the original next() exists; local interface overloads must
// use Iterator's default body and throw IllegalStateException (doc §2).
class T404OriginalOnlyIterator <: Iterator<String> {
    public func next(): Option<String> {
        None
    }
}

func t403HalfDefault(receiver: Iterable<String> @local?): Bool {
    var caught = false
    try {
        let result: Iterator<String> @local? = receiver.iterator()
        let _ = result
    } catch (e: IllegalStateException) {
        caught = true
    }
    caught
}

func t404HalfDefault(receiver: Iterator<String> @local?): Bool {
    var caught = false
    try {
        let result: Option<String> @local? = receiver.next()
        let _ = result
    } catch (e: IllegalStateException) {
        caught = true
    }
    caught
}

func t402HalfLines(half: String @local?): Int64 {
    let lines: Iterator<String> @local? = half.lines()
    var index: Int64 = 0
    var failure: Int64 = 0
    let expected: Array<String> @local! = ["a", "b"]
    var running: Bool = true
    while (running) {
        match (lines.next()) {
            case Some(line) =>
                if (index >= expected.size || line != expected[index]) { failure = 1 }
                index += 1
            case None => running = false
        }
    }
    if (index != expected.size) { failure = 2 }
    failure
}

main(): Int64 {
    var failed = 0

    // T400: original Iterable/Iterator methods through interface static receivers.
    let iterable: Iterable<String> = T400OriginalIterable()
    let iterator: Iterator<String> = iterable.iterator()
    failed += assertEq(iterator.next(), Some("a"), "T400_next_a")
    failed += assertEq(iterator.next(), Some("b"), "T400_next_b")
    failed += assertEq(iterator.next(), None, "T400_next_none")

    // T401: full local receiver and full local result. The byte iterator path is
    // retained as a mode probe; lines() is the reference-payload blocker.
    let fullString: String @local! = "a\nb"
    let fullIterable: Iterable<Byte> @local! = fullString
    let fullBytes: Iterator<Byte> @local! = fullIterable.iterator()
    let fullByte: Option<Byte> @local! = fullBytes.next()
    match (fullByte) {
        case Some(value) => failed += assertEq(value, 0x61u8, "T401_full_iterator_byte")
        case None =>
            failed += 1
            println("FAIL: T401_full_iterator_byte — expected Some(0x61)")
    }
    let fullLines: Iterator<String> @local! = fullString.lines()
    let fullLineA: Option<String> @local! = fullLines.next()
    match (fullLineA) {
        case Some(value) => failed += assertB(value == "a", "T401_full_line_a")
        case None =>
            failed += 1
            println("FAIL: T401_full_line_a — expected Some(\"a\")")
    }
    let fullLineB: Option<String> @local! = fullLines.next()
    match (fullLineB) {
        case Some(value) => failed += assertB(value == "b", "T401_full_line_b")
        case None =>
            failed += 1
            println("FAIL: T401_full_line_b — expected Some(\"b\")")
    }
    let fullLineNone: Option<String> @local! = fullLines.next()
    match (fullLineNone) {
        case Some(_) =>
            failed += 1
            println("FAIL: T401_full_line_none — expected None")
        case None => failed += assertB(true, "T401_full_line_none")
    }

    // T402: half local receiver/result byte path. The SDK has no String
    // @local? lines() overload; preserve its exact doc-correct expectation.
    let halfString: String @local? = "a\nb"
    let halfIterable: Iterable<Byte> @local? = halfString
    let halfBytes: Iterator<Byte> @local? = halfIterable.iterator()
    let halfByte: Option<Byte> @local? = halfBytes.next()
    match (halfByte) {
        case Some(value) => failed += assertEq(value, 0x61u8, "T402_half_iterator_byte")
        case None =>
            failed += 1
            println("FAIL: T402_half_iterator_byte — expected Some(0x61)")
    }
    // T402: `String @local?` 的 lines() 由 std 库提供，逐行返回 "a"、"b"、None。
    failed += assertEq(t402HalfLines(halfString), 0, "T402_half_lines")

    // T403: each missing local Iterable overload is an exact failure, not an
    // implementation-dependent success. Full fixture construction is omitted
    // because custom full construction is the known C10 blocker.
    let defaultIterable = T403OriginalOnlyIterable()
    let defaultIterableHalf: Iterable<String> @local? = defaultIterable
    failed += assertB(t403HalfDefault(defaultIterableHalf), "T403_iterable_half_default")
    // Doc-correct full expectation (C10): T403OriginalOnlyIterable @local! .iterator()
    // must likewise catch IllegalStateException when full fixture construction is available.

    // T404: each missing local Iterator overload is an exact failure.
    let defaultIterator = T404OriginalOnlyIterator()
    let defaultIteratorHalf: Iterator<String> @local? = defaultIterator
    failed += assertB(t404HalfDefault(defaultIteratorHalf), "T404_iterator_next_half_default")
    // Doc-correct full expectation (C10): T404OriginalOnlyIterator @local! .next()
    // must likewise catch IllegalStateException when full fixture construction is available.

    // T405: Iterator.iterator() returns this and shares the cursor.
    let shared: Iterator<String> = T400OriginalIterator()
    failed += assertEq(shared.next(), Some("a"), "T405_shared_first")
    let sameIterator: Iterator<String> = shared.iterator()
    failed += assertEq(sameIterator.next(), Some("b"), "T405_shared_second")
    failed += assertEq(shared.next(), None, "T405_shared_none")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
