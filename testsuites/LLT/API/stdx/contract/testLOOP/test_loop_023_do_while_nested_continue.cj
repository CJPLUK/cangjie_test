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

// CT-LOOP-023: a `continue` inside a loop nested in a do-while body targets the
// inner loop and must not run the outer invariant checks (the do-while `continue`
// rewrite is applied to the enclosing loop's body only; nested loop bodies are
// tracked brace-wise, including the `while` trailer of a nested do-while). Two
// outer iterations with three inner iterations each (one inner `continue` per
// outer pass) yield exactly two outer checks; misattributing the inner
// `continue` would add one extra outer check per outer pass.
var loopDWNestState: Int64 = 0
var loopDWNestOuterChecks: Int64 = 0

func dwNestOuterTick(): Bool {
    loopDWNestOuterChecks += 1
    true
}

@Contract
func dwNestedContinue(): Int64 {
    loopDWNestState = 0
    @loopInvariant[dwNestOuterTick()](do {
        var j = 0
        while (j < 3) {
            j += 1
            if (j == 2) {
                continue
            }
        }
        loopDWNestState += 1
    } while (loopDWNestState < 2))
    loopDWNestState
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        loopDWNestState = 0
        loopDWNestOuterChecks = 0
    }

    @AfterEach
    func tearDown(): Unit {
        loopDWNestState = 0
        loopDWNestOuterChecks = 0
    }

    // The inner `continue` jumps to the inner while condition only; the outer
    // check point still runs exactly once per outer iteration.
    @TestCase
    func testLoop023DoWhileNestedContinueChecks() {
        @Expect(dwNestedContinue(), 2)
        @Expect(loopDWNestOuterChecks, 2)
    }
}
