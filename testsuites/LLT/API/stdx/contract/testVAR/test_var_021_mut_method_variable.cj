/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-021: a `mut` method can declare function-level `variable` clauses. Its body
// is hoisted into a sibling `mut` member, so the holders are boxed into one-element
// arrays and forwarded to that helper: the wrapper keeps the checks, the helper keeps
// the body, and both share the same slots.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract
struct CovVarMutStruct {
    public var total: Int64 = 0

    public init() {}

    // CT-VAR-021: the holder is readable from `requires`/`ensures` and writable in
    // `@ghost`; every call starts from the declared initial value.
    @Contract [
        variable calls: Int64 = 0
        requires n > 0
        ensures r: r == total
        ensures calls == 1
    ]
    public mut func add(n: Int64): Int64 {
        @ghost(calls = calls + 1)
        total += n
        total
    }

    // CT-VAR-022: generic method with a named parameter — the boxed slots are appended
    // after the original arguments and forwarded by name.
    @Contract [
        variable seen: Int64 = 0
        requires n > 0
        ensures seen == n
    ]
    public mut func bump<T>(v: T, n!: Int64): Unit {
        @ghost(seen = n)
        total += n
        let _ = v
    }

    // CT-VAR-023: an uninitialized holder read is still a ghost-state violation.
    @Contract [
        variable missing: Int64
        ensures missing == 0
    ]
    public mut func touch(): Unit {}
}

// CT-VAR-024: an interface-hosted `mut` default body cannot emit a `private` helper.
@Contract []
interface CovVarMutIface {
    @Contract [
        variable calls: Int64 = 0
        ensures calls == 1
    ]
    mut func ping(): Unit {
        @ghost(calls = calls + 1)
    }
}

struct CovVarMutImpl <: CovVarMutIface {
    public init() {}
}

@Test
class Test {
    // CT-VAR-021
    @TestCase
    func testMutStructHolderSharedWithBody() {
        var s = CovVarMutStruct()
        @Expect(s.add(3), 3)
        @Expect(s.add(4), 7)
    }

    // CT-VAR-022
    @TestCase
    func testMutStructGenericForwarding() {
        var s = CovVarMutStruct()
        s.bump<Int64>(7, n: 5)
        @Expect(s.total, 5)
    }

    // CT-VAR-023
    @TestCase
    func testMutStructUninitializedHolder() {
        var s = CovVarMutStruct()
        var caught = false
        try {
            s.touch()
        } catch (e: ContractCheckGhostStateException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-VAR-024
    @TestCase
    func testMutInterfaceDefaultBody() {
        var impl = CovVarMutImpl()
        impl.ping()
    }
}
