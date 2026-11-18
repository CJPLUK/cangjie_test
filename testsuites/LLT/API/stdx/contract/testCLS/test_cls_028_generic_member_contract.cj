/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-028: a member contract on a generic method under a type-level
// `@Contract` must materialize the condition checker with the method's generic
// parameters and `where` clause. Fixed (audit report 3, R1): the generated
// checker used to omit `<T>`/`where`, failing with `undeclared type name 'T'`.
// The inherited `ensures ret: false` must actually fire on the override, which
// proves the generic checker was materialized instead of being skipped
// (audit report 4, T1: the case used to print THROW/NO-THROW without asserting).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.runtime.*
import stdx.contract.macros.*

@Contract []
open class GBase {
    @Contract [ensures [eq] ret: false]
    public open func dup<T>(x: T): T where T <: Comparable<T> { return x }
}

@Contract [inherits from GBase]
class GChild <: GBase {
    public override func dup<T>(x: T): T where T <: Comparable<T> { return x }
}

@Test
class Test {
    @TestCase
    func inheritedGenericEnsuresFires() {
        let g = GChild()
        var thrown = false
        try {
            let value = g.dup<Int64>(1)
            @Expect(value, 1)
        } catch (e: ContractCheckEnsuresException) {
            thrown = true
            @Expect(isContractException(e), true)
        }
        @Expect(thrown, true)
    }
}
