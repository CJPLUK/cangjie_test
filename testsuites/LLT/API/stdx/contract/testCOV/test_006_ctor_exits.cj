/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-006: constructor exit injection across control-flow shapes:
// try-finally, empty catch, catch ending with a declaration, unsafe block,
// and match arms ending in `return`.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [ invariant v >= 0 ]
class CovCtorExits {
    public var v: Int64 = 0
    public var w: Int64 = 0

    public init(mode: Int64) {
        if (mode == 0) {
            return
        }
        try {
            if (mode == 1) {
                return
            }
            v = 1
        } catch (e: Exception) {
            // empty catch block: exit analysis still must not lose the check
        }
        try {
            v = 2
        } catch (e: Exception) {
            let z = 1
            w = z
        } finally {
            w += 1
        }
        match (mode) {
            case 2 =>
                return
            case _ =>
                v = 3
        }
    }

    public init(unsafeMode: Bool) {
        if (unsafeMode) {
            unsafe {
                return
            }
        }
        v = 9
    }
}

@Test
class Test {
    @TestCase
    func testCtorExits() {
        @Expect(CovCtorExits(0).v, 0)
        @Expect(CovCtorExits(1).v, 0)
        @Expect(CovCtorExits(2).v, 2)
        @Expect(CovCtorExits(3).v, 3)
        @Expect(CovCtorExits(true).v, 0)
    }
}
