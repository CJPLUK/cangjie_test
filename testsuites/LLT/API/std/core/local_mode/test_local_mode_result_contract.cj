/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖设计项（LM-DOC-20260910）：T001。

import std.core.*

class T001FullResultText <: ToString {
    public func toString(): String {
        "heap"
    }

    public func toString(this @local?): String @local! {
        exclave {
            let value: String @local! = "full-result"
            value
        }
    }
}

func t001FullValue(source: ToString @local?): String @local! {
    exclave {
        source.toString()
    }
}

func t001OptionInt64(): Option<Int64> @local! {
    exclave {
        Some<Int64>(11)
    }
}

func t001OptionString(): Option<String> @local! {
    exclave {
        let value: String @local! = "a"
        let option: Option<String> @local! = Some(value)
        option
    }
}

func t001TupleStringPayload(): Int64 {
    let pair: (String, String) @local! = ("a", "b")
    if (pair[0] != "a") { return 1 }
    if (pair[1] != "b") { return 2 }
    0
}

main(): Int64 {
    var failed = 0

    // T001: a full-return method is accepted by a full-mode binding.
    let text: T001FullResultText @local? = T001FullResultText()
    let fullValue: String @local! = t001FullValue(text)
    failed += assertB(fullValue == "full-result", "T001_full_return_local_bang")

    // T001: the same full result must not escape to a heap binding.
    // EXPECTED-COMPILE-FAIL (kept as an independent probe):
    // let heapValue: String = t001FullValue(text)
    // The compiler must report a mode mismatch at the binding, not accept it.

    // T001: a half-return method is accepted by a half-mode binding.
    let source: String @local? = "ab"
    let halfIterator: Iterator<Byte> @local? = source.iterator()
    let first: Option<Byte> @local? = halfIterator.next()
    match (first) {
        case Some(value) => failed += assertEq(value, 0x61u8, "T001_half_return_some_payload")
        case None =>
            failed += 1
            println("FAIL: T001_half_return_some_payload — expected Some(0x61)")
    }
    let second: Option<Byte> @local? = halfIterator.next()
    match (second) {
        case Some(value) => failed += assertEq(value, 0x62u8, "T001_half_return_second_payload")
        case None =>
            failed += 1
            println("FAIL: T001_half_return_second_payload — expected Some(0x62)")
    }
    let exhausted: Option<Byte> @local? = halfIterator.next()
    match (exhausted) {
        case Some(_) =>
            failed += 1
            println("FAIL: T001_half_return_exhausted — expected None")
        case None => failed += assertB(true, "T001_half_return_exhausted_none")
    }

    // T001: Option<Int64> local payload is exact on this SDK.
    let fullOption: Option<Int64> @local! = t001OptionInt64()
    match (fullOption) {
        case Some(value) => failed += assertEq(value, 11, "T001_full_option_int64_payload")
        case None =>
            failed += 1
            println("FAIL: T001_full_option_int64_payload — expected Some(11)")
    }

    // T001: local Option 与 tuple 中的 String 载荷保持精确值。
    let optionString: Option<String> @local! = t001OptionString()
    match (optionString) {
        case Some(value) => failed += assertB(value == "a", "T001_option_string_payload")
        case None =>
            failed += 1
            println("FAIL: T001_option_string_payload — expected Some(\"a\")")
    }
    failed += assertEq(t001TupleStringPayload(), 0, "T001_option_tuple_string_payload")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
