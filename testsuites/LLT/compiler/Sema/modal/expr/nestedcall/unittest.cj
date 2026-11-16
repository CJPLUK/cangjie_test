// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output %cmp_utest_opt -Woff all
// EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.testmacro.*

class A {
    init() {}
    exclave init(this @local!) {}
}

class File {
    func read(_: A): Int64 {
        1
    }
    func read(_: A @local!): Int64 {
        2
    }
    func readNamed(x!: A, y!: Int64 = 0): Int64 {
        1
    }
    func readNamed(x!: A @local!, y!: Int64 = 0): Int64 {
        2
    }
}

@Test
class NestedCtorCallTest {
    @TestCase
    func testReadPrefersNonLocal(): Unit {
        let f = File()
        let r = f.read(A())
        @Expect(r, 1)
    }

    @TestCase
    func testNamedArgPrefersNonLocal(): Unit {
        let f = File()
        let r = f.readNamed(x: A())
        @Expect(r, 1)
    }
}
