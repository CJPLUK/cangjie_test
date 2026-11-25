/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-018: a parent contract on a method-level generic type
// parameter keys the member with positional placeholders so a child override
// that renames its type parameter (<T> -> <U>) still matches and inherits.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract []
open class GenMethodBase {
    public init() {}

    @Contract [
        requires n > 0
        ensures n >= 0
    ]
    public open func pick<T>(x: T, n: Int64): T {
        x
    }
}

@Contract [
    inherits from GenMethodBase
]
class GenMethodChild <: GenMethodBase {
    public init() {}

    public override func pick<U>(x: U, n: Int64): U {
        x
    }
}

@Test
class Test {
    @TestCase
    func testGenericMethod() {
        let c = GenMethodChild()
        @Expect(c.pick(42, 1), 42)
    }
}
