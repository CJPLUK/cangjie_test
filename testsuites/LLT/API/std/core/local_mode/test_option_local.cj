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
// Check local Option predicates, unwrapping, and heap overloads.

import std.core.*

exclave func mkHi(): String @local! {
    let v: String @local! = "hi"
    return v
}

// Check predicates and unwrapping for Some.
func someLocal(): Int64 {
    var failed = 0
    let o: Option<String> @local! = Some(mkHi()) @local!
    let oBang: Option<String> @local! = o
    let oHalf: Option<String> @local? = o
    failed += assertB(oBang.isSome(), "some_local_bang_isSome")
    failed += assertB(oHalf.isSome(), "some_local_half_isSome")
    failed += assertB(!oHalf.isNone(), "some_local_half_isNone_false")
    let got1: String @local! = oBang.getOrThrow()
    let got2: String @local! = oBang.getOrThrow({ => Exception("unused") })
    failed += assertEq(String(got1.clone()), "hi", "some_local_getOrThrow")
    failed += assertEq(String(got2.clone()), "hi", "some_local_getOrThrow_exception")
    return failed
}

// Check predicates and exceptions for None.
func noneLocal(): Int64 {
    var failed = 0
    let o: Option<String> @local! = None
    let oBang: Option<String> @local! = o
    let oHalf: Option<String> @local? = o
    failed += assertB(!oBang.isSome(), "none_local_bang_isSome_false")
    failed += assertB(oBang.isNone(), "none_local_bang_isNone")
    failed += assertB(oHalf.isNone(), "none_local_half_isNone")
    // Unwrapping None must throw NoneValueException.
    try {
        let _ = oBang.getOrThrow()
        failed += 1
        println("FAIL: none_local_getOrThrow — expected NoneValueException")
    } catch (e: NoneValueException) {}
    // Preserve the caller-supplied exception and message.
    try {
        let _ = oBang.getOrThrow({ => Exception("boom") })
        failed += 1
        println("FAIL: none_local_getOrThrow_exception — expected Exception")
    } catch (e: Exception) {
        if (e.message != "boom") { failed += 1; println("FAIL: none_local exception message") }
    }
    return failed
}

// Heap overloads retain their behavior.
func plainUnaffected(): Int64 {
    var failed = 0
    let some: Option<String> = Some("hi")
    let none: Option<String> = None
    failed += assertB(some.isSome(), "plain_some_isSome")
    failed += assertB(!none.isSome(), "plain_none_isSome_false")
    failed += assertB(none.isNone(), "plain_none_isNone")
    failed += assertEq(some.getOrThrow(), "hi", "plain_some_getOrThrow")
    try {
        let _ = none.getOrThrow()
        failed += 1
    } catch (e: NoneValueException) {}
    return failed
}

main(): Int64 {
    var failed = 0
    failed += someLocal()
    failed += noneLocal()
    failed += plainUnaffected()
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
