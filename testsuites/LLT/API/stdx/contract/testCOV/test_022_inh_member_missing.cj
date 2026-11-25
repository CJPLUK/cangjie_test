/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-022: a member-level reference to a type that is not a declared
// parent, and a selective property inheritance whose parent property carries no
// contract attribute at all.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inheritance reference does not match a declared parent type: `StrangerBase`
// ASSERT: scan no inherited contract matches the requested kind and name: `NoPropBase.g`
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract []
open class StrangerBase {
    public init() {}

    @Contract [
        requires [r] x > 0
    ]
    public open func act(x: Int64): Int64 {
        x
    }
}

@Contract []
class NotParentChild {
    public init() {}

    @Contract [
        inherits requires r = StrangerBase.r
    ]
    public func act(x: Int64): Int64 {
        x
    }
}

@Contract []
open class NoPropBase {
    public init() {}

    public open mut prop size: Int64 {
        get() {
            0
        }
        set(value) {
        }
    }
}

@Contract []
class NoPropChild <: NoPropBase {
    public init() {}

    @Contract [
        get {
            inherits ensures g = NoPropBase.g
        }
    ]
    public override mut prop size: Int64 {
        get() {
            1
        }
        set(value) {
        }
    }
}

main(): Int64 {
    0
}
