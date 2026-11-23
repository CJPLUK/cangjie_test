/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// CT-INH-043 (defect 16.10): a generic parent publishes member contracts keyed by its
// formal type parameters (`step(T,T)`); after `inherits from GenKeyBase<Int64>` the keys,
// clause bodies and member signatures must be instantiated, so the child's
// `step(Int64,Int64)` override replays them both implicitly and through an explicit
// `inherits requires` clause.
import stdx.contract.macros.*
import stdx.contract.runtime.*

@Contract
open class GenKeyBase<T> where T <: Equatable<T> {
    public init() {}

    @Contract[
        requires [neq] x != y
        ensures [echo] r: r != y
    ]
    public open func step(x: T, y: T): T {
        x
    }
}

// Implicit replay: the child declares no member contract of its own; the inherited
// `requires`/`ensures` must still fire on the Int64 instantiation.
@Contract[
    inherits from GenKeyBase<Int64>
]
class GenKeyImplicit <: GenKeyBase<Int64> {
    public init() {
        super()
    }

    public override func step(x: Int64, y: Int64): Int64 {
        x
    }
}

// Explicit replay: `inherits requires` must match the parent contract through the
// instantiated signature key.
@Contract[
    inherits from GenKeyBase<Int64>
]
class GenKeyExplicit <: GenKeyBase<Int64> {
    public init() {
        super()
    }

    @Contract[
        inherits requires GenKeyBase<Int64>.neq
    ]
    public override func step(x: Int64, y: Int64): Int64 {
        x
    }
}

@Test
class Test {
    // CT-INH-043
    @TestCase
    func testInh043GenericMemberKey() {
        var implicit = false
        try {
            GenKeyImplicit().step(3, 3)
        } catch (e: ContractCheckRequiresException) {
            implicit = true
        }
        @Expect(implicit, true)
        @Expect(GenKeyImplicit().step(3, 4), 3)

        var explicit = false
        try {
            GenKeyExplicit().step(3, 3)
        } catch (e: ContractCheckRequiresException) {
            explicit = true
        }
        @Expect(explicit, true)
        @Expect(GenKeyExplicit().step(3, 4), 3)
    }
}
