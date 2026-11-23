/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-EXT-001/002/006: contracts on `extend` members are checked. CT-EXT-007
// cannot be landed as designed: the language rejects `extend <interface>` at
// compile time (landed as a negative file in this directory). CT-EXT-008
// (checks off) is covered by the compile-time `contract_check` dual build, not
// by runtime switching (design §3.5 / R8).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// ---------- shared fixtures ----------

// CT-EXT-001: member functions introduced by `extend` carry full function
// contracts; the extended class itself declares none.
class ExtBase {
    public func baseValue(): Int64 {
        1
    }
}

extend ExtBase {
    @Contract[
        requires (n > 0)
        ensures r: r == n * 2
    ]
    public func extDouble(n: Int64): Int64 {
        n * 2
    }

    // Same clauses but a body that violates `ensures`.
    @Contract[
        requires (n > 0)
        ensures r: r == n * 2
    ]
    public func extDoubleBroken(n: Int64): Int64 {
        n
    }

    // CT-EXT-002: `@contractAssert` inside an extend member body.
    @Contract
    public func extBrokenAssert(): Int64 {
        @contractAssert(false)
        1
    }
}

// CT-EXT-006: generic extend. The clause conditions only reference the Int64
// argument, so every instantiation is checked with the same contract.
class ExtBox<T> {
    public let value: T
    public init(v: T) {
        value = v
    }
}

extend<T> ExtBox<T> {
    @Contract[
        requires (n > 0)
        ensures r: r == n
    ]
    public func tag(n: Int64): Int64 {
        n
    }
}

// CT-EXT-011: a struct host's extend members carry contracts too.
struct ExtStructHost {
    let base: Int64 = 1
}

extend ExtStructHost {
    @Contract[
        requires n >= 0
        ensures r: r == n + 1
    ]
    public func bump(n: Int64): Int64 {
        n + 1
    }
}

// CT-EXT-012: getter prop contracts declared inside an extend are enforced;
// a broken getter postcondition throws from the read path. (Storage-backed
// `mut prop` cannot be declared in an extend; getter-only is the form the
// language allows here.)
struct ExtPropHost {}

extend ExtPropHost {
    @Contract[
        get ensures r: r == 42
    ]
    public prop answer: Int64 {
        get() {
            42
        }
    }

    @Contract[
        get ensures r: r < 0
    ]
    public prop badAnswer: Int64 {
        get() {
            42
        }
    }
}

@Test
class Test {
    // CT-EXT-001: requires/ensures on an extend member are both enforced.
    @TestCase
    func testExt001ExtendMemberContracts() {
        let b = ExtBase()
        @Expect(b.extDouble(2), 4)
        var reqCaught = false
        try {
            b.extDouble(-1)
        } catch (e: ContractCheckRequiresException) {
            reqCaught = true
        }
        @Expect(reqCaught, true)
        var ensCaught = false
        try {
            b.extDoubleBroken(2)
        } catch (e: ContractCheckEnsuresException) {
            ensCaught = true
        }
        @Expect(ensCaught, true)
    }

    // CT-EXT-002: a false `@contractAssert` in an extend member body throws.
    @TestCase
    func testExt002ContractAssertInExtend() {
        var caught = false
        try {
            ExtBase().extBrokenAssert()
        } catch (e: ContractCheckAssertException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-EXT-006: generic extend contracts are checked per instantiation.
    @TestCase
    func testExt006GenericExtendContracts() {
        let bi = ExtBox<Int64>(1)
        let bs = ExtBox<String>("x")
        @Expect(bi.tag(3), 3)
        @Expect(bs.tag(4), 4)
        var caught = false
        try {
            bi.tag(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-EXT-011: the struct host's extend member contract is enforced on
    // both sides.
    @TestCase
    func testExt011StructHost() {
        let s = ExtStructHost()
        @Expect(s.bump(1), 2)
        var caught = false
        try {
            let _ = s.bump(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-EXT-012: the extend getter prop contract passes for a valid getter
    // and throws for a broken one.
    @TestCase
    func testExt012ExtendProp() {
        let h = ExtPropHost()
        @Expect(h.answer, 42)
        var caught = false
        try {
            let _ = h.badAnswer
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
