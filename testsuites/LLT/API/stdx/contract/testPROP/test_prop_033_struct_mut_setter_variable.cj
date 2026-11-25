/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-PROP-033: a function-level `variable` declared by a struct's `mut prop` setter
// contract. The setter body is hoisted into a sibling `mut` member, so the holder is
// boxed and forwarded to that helper: the wrapper keeps the checks, the helper keeps
// the body, and both share the same slot.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract
struct PropMutSetterVar {
    private var stored: Int64 = 0

    public init() {}

    @Contract [
        set variable hits: Int64 = 0
        set requires value > 0
        set ensures hits == 1
    ]
    public mut prop score: Int64 {
        get() {
            stored
        }
        set(v) {
            @ghost(hits = hits + 1)
            stored = v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

@Test
class Test {
    // CT-PROP-033 (positive): the shared slot is updated by the hoisted body and the
    // wrapper postcondition sees it; every assignment starts from the initial value.
    @TestCase
    func prop033SetterVariableSharedWithBody() {
        var q = PropMutSetterVar()
        q.score = 5
        @Expect(q.peek(), 5)
        q.score = 6
        @Expect(q.peek(), 6)
    }

    // CT-PROP-033 (negative): the precondition still stops the setter body.
    @TestCase
    func prop033SetterRequiresEnforced() {
        var q = PropMutSetterVar()
        var caught = false
        try {
            q.score = -1
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(q.peek(), 0)
    }
}
