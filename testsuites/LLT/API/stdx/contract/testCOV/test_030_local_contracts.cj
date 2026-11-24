/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-030: `@Contract` on local functions nested inside member bodies
// must be absorbed wherever they are declared: straight-line body, if/else
// branches, try/catch/finally, match cases, and synchronized blocks.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [ invariant ok >= 0 ]
class CovLocals {
    public var ok: Int64 = 0
    public init() {}

    public func demo(n: Int64): Int64 {
        @Contract [ requires x > 0 ]
        func helper(x: Int64): Int64 {
            x + 1
        }
        var r = helper(n)
        if (n > 0) {
            @Contract [ requires x > 0 ]
            func inIf(x: Int64): Int64 {
                x + 2
            }
            r += inIf(n)
        } else {
            @Contract [ ensures out: out > 0 ]
            func inElse(x: Int64): Int64 {
                x + 3
            }
            r += inElse(n)
        }
        try {
            @Contract [ requires x > 0 ]
            func inTry(x: Int64): Int64 {
                x + 4
            }
            r += inTry(n)
        } catch (e: Exception) {
            @Contract [ ensures out: out > 0 ]
            func inCatch(x: Int64): Int64 {
                x + 5
            }
            r += inCatch(n)
        } finally {
            @Contract [ requires x > 0 ]
            func inFinally(x: Int64): Int64 {
                x + 6
            }
            r += inFinally(n)
        }
        match (n) {
            case 1 =>
                @Contract [ requires x > 0 ]
                func inCase(x: Int64): Int64 {
                    x + 7
                }
                r += inCase(n)
            case _ =>
                r += 1
        }
        ok = r
        r
    }
}

@Test
class Test {
    @TestCase
    func testLocalContracts() {
        let c = CovLocals()
        @Expect(c.demo(1), 25)
    }
}
