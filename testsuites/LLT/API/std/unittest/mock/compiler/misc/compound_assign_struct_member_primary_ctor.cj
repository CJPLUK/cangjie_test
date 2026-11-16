/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC-0: %compiler %cmp_opt -Woff=all --mock=on --test %f -o %output 2>&1
// EXEC-0: %run %run_opt %output %run_utest_opt %run_args 2>&1

import std.unittest.*
import std.unittest.mock.*
import std.unittest.testmacro.*
import std.unittest.mock.mockmacro.*

struct S {
    S(var v: UInt64) { }
}

class C {
    C(var s: S) { }
}

extend C {
    public func addMa(n: UInt64) {
        this.s.v += n
    }

    public func addRef(n: UInt64) {
        s.v += n
    }
}

func add(lhs: C, n: UInt64) {
    lhs.s.v += n
}

main() {}

@Test
func testSpy(): Unit {
    let c = spy<C>(C(S(0)))
    c.addRef(1)
    c.addMa(2)
    add(c, 4)

    Verify.that(@Called(c.s).times(3))
    @Assert(c.s.v, 7)
}
