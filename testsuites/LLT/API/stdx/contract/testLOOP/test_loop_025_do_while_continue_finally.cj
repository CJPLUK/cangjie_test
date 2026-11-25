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

// CT-LOOP-025: a `continue` in a do-while body runs the `finally` blocks it
// leaves before jumping to the loop condition. The check point sits after those
// `finally` blocks and before the condition, so a `finally` that advances the
// loop state is observed by the check of the same iteration. The tick records
// the state it sees: with `continue` on the second iteration and the state
// advanced in `finally`, it must observe 1, 2, 3 (a check placed at the
// `continue` site would observe 1, 1, 3).
var loopDWFinallyState: Int64 = 0
var loopDWFinallyChecks: Int64 = 0
var loopDWFinallySeen: String = ""

func dwFinallyTick(): Bool {
    loopDWFinallyChecks += 1
    loopDWFinallySeen += "${loopDWFinallyState}"
    true
}

@Contract
func dwFinallyContinueLoop(): Int64 {
    loopDWFinallyState = 0
    @loopInvariant[dwFinallyTick()](do {
        try {
            if (loopDWFinallyState == 1) {
                continue
            }
        } finally {
            loopDWFinallyState += 1
        }
    } while (loopDWFinallyState < 3))
    loopDWFinallyState
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        loopDWFinallyState = 0
        loopDWFinallyChecks = 0
        loopDWFinallySeen = ""
    }

    @AfterEach
    func tearDown(): Unit {
        loopDWFinallyState = 0
        loopDWFinallyChecks = 0
        loopDWFinallySeen = ""
    }

    // The check of the `continue` iteration runs after its `finally`, so every
    // check observes the state already advanced by that iteration.
    @TestCase
    func testLoop025DoWhileContinueAfterFinally() {
        @Expect(dwFinallyContinueLoop(), 3)
        @Expect(loopDWFinallyChecks, 3)
        @Expect(loopDWFinallySeen, "123")
    }
}
