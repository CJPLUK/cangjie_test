/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-012: `extend` member contract generation: function and property
// contracts written directly on extend members, the contract inherited
// through `@Contract[inherits from I]` on an extend, generic extends and struct
// hosts (host-agnostic property wrapper), and the conforming replay branch.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class CovGenExtHost {
    public init() {}
}

extend CovGenExtHost {
    @Contract [
        requires n > 0
        ensures r: r == n * 2
    ]
    public func doubled(n: Int64): Int64 {
        n * 2
    }

    @Contract [
        get ensures r: r == 42
    ]
    public prop answer: Int64 {
        get() {
            42
        }
    }
}

// Generic extend: the contract is checked once per instantiation.
class CovGenExtBox<T> {
    public let value: T
    public init(v: T) {
        value = v
    }
}

extend<T> CovGenExtBox<T> {
    @Contract [
        requires n >= 0
        ensures r: r == n
    ]
    public func identity(n: Int64): Int64 {
        n
    }
}

// Struct host: the generated property wrapper must be host agnostic.
struct CovGenExtStruct {
    let base: Int64 = 1
}

extend CovGenExtStruct {
    @Contract [
        requires n >= 0
        ensures r: r == n + 1
    ]
    public func bump(n: Int64): Int64 {
        n + 1
    }

    @Contract [
        get ensures r: r >= 0
    ]
    public prop size: Int64 {
        get() {
            3
        }
    }
}

// Contract inherited by an extend through `inherits from`.
@Contract []
interface CovGenExtIface {
    @Contract [requires x > 0]
    func fromIface(x: Int64): Int64
}

class CovGenExtInheritHost {}

@Contract [inherits from CovGenExtIface]
extend CovGenExtInheritHost <: CovGenExtIface {
    public func fromIface(x: Int64): Int64 {
        x
    }
}

// `[conforming]` extend: only `ensures` is added by the extension member.
@Contract
interface CovGenExtConfIface {
    @Contract [requires x > 0]
    func confExt(x: Int64): Int64
}

class CovGenExtConfHost {}

@Contract [inherits from CovGenExtConfIface [conforming]]
extend CovGenExtConfHost <: CovGenExtConfIface {
    @Contract [ensures r: r > 0]
    public func confExt(x: Int64): Int64 {
        x
    }
}

@Test
class Test {
    @TestCase
    func testExtendFunctionAndProperty() {
        let host = CovGenExtHost()
        @Expect(host.doubled(2), 4)
        @Expect(host.answer, 42)
        var caught = false
        try {
            host.doubled(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    @TestCase
    func testGenericExtend() {
        @Expect(CovGenExtBox<Int64>(0).identity(3), 3)
        @Expect(CovGenExtBox<String>("x").identity(4), 4)
    }

    @TestCase
    func testStructExtend() {
        let s = CovGenExtStruct()
        @Expect(s.bump(1), 2)
        @Expect(s.size, 3)
    }

    @TestCase
    func testInheritedExtendContract() {
        let host = CovGenExtInheritHost()
        @Expect(host.fromIface(3), 3)
        var caught = false
        try {
            host.fromIface(-3)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    @TestCase
    func testConformingExtend() {
        @Expect(CovGenExtConfHost().confExt(3), 3)
    }
}
