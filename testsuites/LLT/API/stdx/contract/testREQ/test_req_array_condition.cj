/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.runtime.*
import stdx.contract.macros.*

// CT-REQ-012: a condition that starts with an array literal must keep the
// brackets: `[flag] == [true]` is an array comparison, not a clause named
// `flag` (audit 16.22 — the label parser used to swallow `[flag]` and the
// clause failed with a generic parse error).
// Audit report 4, T2: the case used to only print the results; it now asserts
// both the satisfied and the violated branch.
@Contract[
    requires [flag] == [true]
]
func arraySingle(flag: Bool): Int64 {
    1
}

// CT-REQ-013: multi-element array literals compare element-wise.
@Contract[
    requires [n, n] == [n, n]
]
func arrayPair(n: Int64): Int64 {
    n
}

// CT-REQ-014: the actual labeled clause form keeps working.
@Contract[
    requires [label] n > 0
]
func labeledClause(n: Int64): Int64 {
    n
}

@Test
class Test {
    // The three array-shaped conditions hold for valid inputs.
    @TestCase
    func arrayConditionsHold() {
        @Expect(arraySingle(true), 1)
        @Expect(arrayPair(2), 2)
        @Expect(labeledClause(3), 3)
    }

    // `[flag] == [true]` is evaluated as an array comparison, so `false`
    // violates the precondition.
    @TestCase
    func arraySingleFalseThrows() {
        var caught = false
        try {
            arraySingle(false)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // The labeled form still gates the body.
    @TestCase
    func labeledClauseZeroThrows() {
        var caught = false
        try {
            labeledClause(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }
}
