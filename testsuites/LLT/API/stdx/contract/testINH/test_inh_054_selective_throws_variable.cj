/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-054 (audit H6): selective inheritance used to match only `requires` and
// `ensures`; `inherits throws|variable <type>.<name>` was silently dropped and
// reported as "no inherited contract matches".
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class InhSelEx <: Exception {
    public init(message: String) {
        super(message)
    }
}

@Contract
open class InhSelBase {
    public init() {}

    @Contract [
        throws [t] InhSelEx if flag
        variable extra: Int64 = 1
    ]
    public open func act(flag: Bool): Unit {}
}

// `inherits throws`: a true condition with a normal return violates the clause.
@Contract
class InhSelThrows <: InhSelBase {
    public init() {
        super()
    }

    @Contract [
        inherits throws InhSelBase.t
    ]
    public override func act(flag: Bool): Unit {}
}

// `inherits variable`: the clause must match instead of failing the expansion.
@Contract
class InhSelVariable <: InhSelBase {
    public init() {
        super()
    }

    @Contract [
        inherits variable InhSelBase.extra
    ]
    public override func act(flag: Bool): Unit {}
}

@Test
class Test {
    @TestCase
    func testInh054SelectiveThrowsVariable() {
        var caught = false
        try {
            InhSelThrows().act(true)
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)
        InhSelThrows().act(false)
        InhSelVariable().act(false)
    }
}
