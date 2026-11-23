/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-RUN-018 (audit report 4, T8): the global contract switch. The
// `contract_check` compile-time default ("on") is baked into
// stdx.contract.runtime, so the shipped runtime starts enabled and a consumer
// cannot flip it with `--cfg`. The runtime half of the switch,
// `disableContractChecks()`, is one-way. This case pins the observable
// consequences of demotion: `contractCheckEnabled()` turns false, violations
// stop throwing, contract expressions stop being evaluated, `@ghost` bodies
// stop running, and auxiliary-variable storage plus its declared initial value
// are still created (the initializer is emitted unconditionally).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.runtime.*
import stdx.contract.macros.*

var requiresEvals: Int64 = 0
var ghostRuns: Int64 = 0
var auxInitRuns: Int64 = 0

func countRequires(): Bool {
    requiresEvals += 1
    true
}

func auxSeed(): Int64 {
    auxInitRuns += 1
    7
}

@Contract[
    requires countRequires()
]
func gated(n: Int64): Int64 {
    n
}

@Contract[
    requires false
]
func violating(): Int64 {
    1
}

@Contract
class GhostGate {
    @Contract[
        requires n >= 0
    ]
    public func run(n: Int64): Unit {
        @ghost(
            ghostRuns += 1
        )
    }
}

@Contract[
    variable aux: Int64 = auxSeed()
]
class AuxInit {
    public init() {}
}

@Test
class Test {
    @TestCase
    func contractSwitchDemotes() {
        // Enabled by default: the gate reports true and conditions evaluate.
        @Expect(contractCheckEnabled(), true)
        @Expect(gated(1), 1)
        @Expect(requiresEvals, 1)

        var blocked = false
        try {
            violating()
        } catch (e: ContractCheckRequiresException) {
            blocked = true
        }
        @Expect(blocked, true)

        GhostGate().run(1)
        @Expect(ghostRuns, 1)

        // One-way runtime demotion.
        disableContractChecks()
        @Expect(contractCheckEnabled(), false)

        // Contract expressions are no longer evaluated.
        @Expect(gated(2), 2)
        @Expect(requiresEvals, 1)

        // Violations are no longer reported.
        @Expect(violating(), 1)

        // `@ghost` bodies no longer run.
        GhostGate().run(2)
        @Expect(ghostRuns, 1)

        // Auxiliary-variable storage and its initializer still exist.
        let _ = AuxInit()
        @Expect(auxInitRuns, 1)
    }
}
