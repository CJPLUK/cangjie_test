/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-VAR-001~004/006/008/009/011~013 runtime cases. CT-VAR-005 is a
// compile-negative and CT-VAR-010 a compile-positive control (implementation
// difference R-VAR-2: the body can access the auxiliary variable) in their own
// files. CT-VAR-007 (checks off) is covered by the compile-time
// `contract_check` dual build (design §3.5 / R8).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// ---------- shared fixtures ----------

var varCallCount = 0

// CT-VAR-001: the auxiliary variable participates with its initial value.
@Contract[
    variable v: Int64 = 0
    ensures v == 0
]
func varInitial(): Unit {}

// CT-VAR-002: an uninitialized auxiliary variable is initialized in @ghost.
@Contract[
    variable v: Int64
    ensures v == 1
]
func varGhostInit(): Unit {
    @ghost(v = 1)
}

// CT-VAR-003: @ghost updates are observed by ensures.
@Contract[
    variable v: Int64 = 0
    ensures v == 1
]
func varGhostUpdate(): Unit {
    @ghost(v = v + 1)
}

// CT-VAR-004: a variable declared inside @ghost is usable within that @ghost
// block and its value can flow into a contract auxiliary variable. Note
// (R-VAR-3): the declaration is scoped to its own @ghost expansion; the
// design's "referenced by a later @contractAssert" is not supported by the
// implementation and is recorded as a difference.
@Contract[
    variable v: Int64 = 0
    ensures v == 42
]
func varGhostDeclare(): Unit {
    @ghost(
        let g = 42
        v = g
    )
}

// CT-VAR-006: @ghost as a standalone Unit statement.
@Contract[
    variable v: Int64 = 0
    ensures v == 0
]
func varGhostStandalone(): Unit {
    @ghost(v = 0)
}

// CT-VAR-008: single-line and multi-line @ghost forms.
@Contract[
    variable v: Int64 = 0
    ensures v == 3
]
func varGhostSyntax(): Unit {
    @ghost(v = v + 1)
    @ghost(
        v = v + 1
        v = v + 1
    )
}

// CT-VAR-009: reading an auxiliary variable that was never initialized is a
// ghost-state violation.
@Contract[
    variable v: Int64
    ensures v == 0
]
func varUninit(): Unit {}

// CT-VAR-011: every call re-creates and re-initializes the auxiliary variable.
@Contract[
    variable v: Int64 = 0
    ensures v == 1
]
func varFreshPerCall(): Unit {
    varCallCount += 1
    @ghost(v = v + 1)
}

// CT-VAR-012: each recursion level gets its own auxiliary variable instance.
@Contract[
    variable depth: Int64 = 0
    ensures depth == n
]
func varRec(n: Int64): Int64 {
    @ghost(depth = n)
    if (n > 0) {
        varRec(n - 1)
    }
    n
}

// CT-VAR-013: if / while / continue / break inside @ghost follow the language
// semantics (R4): the skip at i == 2 and the immediate break leave v == 4.
@Contract[
    variable v: Int64 = 0
    ensures v == 4
]
func varGhostControl(n: Int64): Unit {
    @ghost(
        var i = 0
        while (i < n) {
            i += 1
            if (i == 2) {
                continue
            }
            v += 1
        }
        while (true) {
            v += 1
            break
        }
    )
}

@Test
class Test {
    // CT-VAR-001
    @TestCase
    func testVar001InitialValue() {
        var failed = false
        try {
            varInitial()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-VAR-002
    @TestCase
    func testVar002GhostInitialization() {
        var failed = false
        try {
            varGhostInit()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-VAR-003
    @TestCase
    func testVar003GhostUpdateObserved() {
        var failed = false
        try {
            varGhostUpdate()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-VAR-004
    @TestCase
    func testVar004GhostDeclaredVariableVisible() {
        var failed = false
        try {
            varGhostDeclare()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-VAR-006
    @TestCase
    func testVar006StandaloneStatement() {
        var failed = false
        try {
            varGhostStandalone()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-VAR-008
    @TestCase
    func testVar008SyntaxForms() {
        var failed = false
        try {
            varGhostSyntax()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-VAR-009
    @TestCase
    func testVar009GhostStateViolation() {
        var caught = false
        try {
            varUninit()
        } catch (e: ContractCheckGhostStateException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-VAR-011
    @TestCase
    func testVar011FreshPerCall() {
        varCallCount = 0
        var failed = false
        try {
            varFreshPerCall()
            varFreshPerCall()
            varFreshPerCall()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
        @Expect(varCallCount, 3)
    }

    // CT-VAR-012
    @TestCase
    func testVar012RecursionIndependent() {
        var result = 0
        var failed = false
        try {
            result = varRec(5)
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
        @Expect(result, 5)
    }

    // CT-VAR-013
    @TestCase
    func testVar013GhostControlFlow() {
        var failed = false
        try {
            varGhostControl(4)
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }
}
