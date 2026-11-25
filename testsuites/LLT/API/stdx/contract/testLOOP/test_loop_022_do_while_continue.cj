/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// CT-LOOP-022: a `continue` in a do-while body still reaches the loop invariant
// check point (design 3.2.6.2: the check point sits between the body and the
// condition). Five iterations with one `continue` still yield exactly five
// checks; a `continue` that skipped the check point would yield only four.
var loopDWContinueState: Int64 = 0
var loopDWContinueChecks: Int64 = 0

func dwContinueTick(): Bool {
    loopDWContinueChecks += 1
    true
}

@Contract
func dwContinueLoop(): Int64 {
    loopDWContinueState = 0
    @loopInvariant[dwContinueTick()](do {
        loopDWContinueState += 1
        if (loopDWContinueState == 2) {
            continue
        }
    } while (loopDWContinueState < 5))
    loopDWContinueState
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        loopDWContinueState = 0
        loopDWContinueChecks = 0
    }

    @AfterEach
    func tearDown(): Unit {
        loopDWContinueState = 0
        loopDWContinueChecks = 0
    }

    // The `continue` iteration runs its check point before jumping to the
    // loop condition, so the per-iteration count is unchanged.
    @TestCase
    func testLoop022DoWhileContinueChecks() {
        @Expect(dwContinueLoop(), 5)
        @Expect(loopDWContinueChecks, 5)
    }
}
