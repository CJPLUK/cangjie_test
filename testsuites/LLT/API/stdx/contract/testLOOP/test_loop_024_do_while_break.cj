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

// CT-LOOP-024: `break` leaves a do-while loop directly, so it skips the
// trailing invariant check point of the iteration in which it fires (the check
// sits between the body and the condition; `break` never reaches it). Three
// body executions with `break` on the third yield exactly two checks; a `break`
// that also ran the check point would report three.
var loopDWBreakState: Int64 = 0
var loopDWBreakChecks: Int64 = 0

func dwBreakTick(): Bool {
    loopDWBreakChecks += 1
    true
}

@Contract
func dwBreakLoop(): Int64 {
    loopDWBreakState = 0
    @loopInvariant[dwBreakTick()](do {
        loopDWBreakState += 1
        if (loopDWBreakState == 3) {
            break
        }
    } while (loopDWBreakState < 10))
    loopDWBreakState
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        loopDWBreakState = 0
        loopDWBreakChecks = 0
    }

    @AfterEach
    func tearDown(): Unit {
        loopDWBreakState = 0
        loopDWBreakChecks = 0
    }

    // The breaking iteration exits without its check point; only the two
    // completed iterations are observed.
    @TestCase
    func testLoop024DoWhileBreakChecks() {
        @Expect(dwBreakLoop(), 3)
        @Expect(loopDWBreakChecks, 2)
    }
}
