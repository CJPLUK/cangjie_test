/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt -Woff=all --test %f -o %output 2>&1
// EXEC-0: %run %run_opt %output %run_utest_opt %run_args 2>&1
import std.unittest.*
import std.unittest.testmacro.*
import std.unittest.mock.*
import std.unittest.mock.mockmacro.*

class C {
    func fooOption<T>(x: ?T): ?T {
        return x
    }

    func fooTuple<T, R>(x: (T, R)): (T, R) {
        return x
    }

    func fooParen<T>(x: (T)): (T) {
        return x
    }

    func fooComplex<T, R>(x: (?(?(T), (?R)))): (?(?(T), (?R))) {
        return x
    }
}

@Test
func test() {
    let c = mock<C>();
    @On(c.fooOption<String>(_)).returns(Some("mocked"))
    @On(c.fooTuple<String, Int>(_)).returns(("mocked", 42))
    @On(c.fooParen<String>(_)).returns("mocked")
    @On(c.fooComplex<String, Int>(_)).returns(Some((Some("mocked"), Some(41))))

    @Assert(c.fooOption(Some("original")), Some("mocked"))
    let (tupleText, tupleNumber) = c.fooTuple(("original", 87))
    @Assert(tupleText, "mocked")
    @Assert(tupleNumber, 42)
    @Assert(c.fooParen("original"), "mocked")
    let (complexText, complexNumber) = c.fooComplex<String, Int>(None).getOrThrow()
    @Assert(complexText, Some("mocked"))
    @Assert(complexNumber, Some(41))
}
