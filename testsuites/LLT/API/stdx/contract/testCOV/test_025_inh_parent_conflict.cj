/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-025: two parent interfaces contribute the same contract name on
// the same method signature and on the same property; both conflicts are
// reported while the differing clause texts are still merged.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited contracts for `act(Int64)`
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract []
public interface ConflictLeft {
    @Contract [
        requires [r] x > 0
    ]
    func act(x: Int64): Int64

    @Contract [
        get {
            ensures [g] ret: ret >= 0
        }
    ]
    mut prop size: Int64
}

@Contract []
public interface ConflictRight {
    @Contract [
        requires [r] x > 0 && x < 1000
    ]
    func act(x: Int64): Int64

    @Contract [
        get {
            ensures [g] ret: ret >= 1
        }
    ]
    mut prop size: Int64
}

@Contract [
    inherits from ConflictLeft
    inherits from ConflictRight
]
class ConflictChild <: ConflictLeft & ConflictRight {
    private var store: Int64 = 0

    public init() {}

    public func act(x: Int64): Int64 {
        x
    }

    public mut prop size: Int64 {
        get() {
            store
        }
        set(value) {
            store = value
        }
    }
}

main(): Int64 {
    0
}
