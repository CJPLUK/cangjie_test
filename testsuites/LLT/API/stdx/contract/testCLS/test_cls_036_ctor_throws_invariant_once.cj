/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-036 (audit M1): the invariant of a constructor that also carries a
// `throws` clause used to be evaluated twice on the normal exit path (the
// `throws` normal-exit gate was mistaken for a constructor exit check), which is
// observable when the invariant has side effects.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

var clsInvEvaluations: Int64 = 0

func clsInvTick(): Bool {
    clsInvEvaluations += 1
    true
}

class ClsThrowsEx <: Exception {
    public init(message: String) {
        super(message)
    }
}

@Contract [
    invariant [tick] clsInvTick()
]
class ClsThrowsCtor {
    var value: Int64 = 0

    @Contract [
        throws [t] ClsThrowsEx if value > 100
    ]
    init() {}
}

@Test
class Test {
    @TestCase
    func testCls036CtorThrowsInvariantOnce() {
        clsInvEvaluations = 0
        let _ = ClsThrowsCtor()
        @Expect(clsInvEvaluations, 1)
    }
}
