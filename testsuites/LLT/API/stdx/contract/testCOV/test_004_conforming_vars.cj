/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-004: `[conforming]` inheritance where the parent declares class-level
// abstract variables, so the conforming invariant scan has inherited variables to
// compare against. Also covers struct hosts inheriting an interface contract and a
// generic struct host.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable base: Int64 = 4
    invariant [baseOk] base > 0
]
open class ConfVarBase {
    public var total: Int64 = 0

    public init() {}

    @Contract [ requires d >= 0 ]
    public open func add(d: Int64): Unit {
        total += d
    }
}

@Contract [
    inherits from ConfVarBase [conforming]
    variable extra: Int64 = 2
    variable limit: Int64 = 100
    invariant [ownOk] extra >= 0 && total >= 0
    invariant [limOk] limit > 0
]
class ConfVarChild <: ConfVarBase {
    public init() {
        super()
    }

    @Contract [ ensures r: total >= 0 ]
    public override func add(d: Int64): Unit {
        total += d + extra
    }
}

@Contract [
    variable cap: Int64 = 5
    invariant [capOk] cap > 0
]
interface ConfVarIface {
    @Contract [ requires x >= 0 ]
    func take(x: Int64): Int64
}

@Contract [ inherits from ConfVarIface ]
struct ConfVarStruct <: ConfVarIface {
    public var seen: Int64 = 0

    public func take(x: Int64): Int64 {
        x
    }
}

@Contract [ variable tag: Int64 = 1 ]
interface ConfVarGenI<T> {
    @Contract [ requires true ]
    func pick(x: T): T
}

@Contract [ inherits from ConfVarGenI<T> ]
struct ConfVarGenS<T> <: ConfVarGenI<T> {
    public func pick(x: T): T {
        x
    }
}

@Test
class Test {
    @TestCase
    func testConformingChild() {
        let c = ConfVarChild()
        c.add(1)
        @Expect(c.total, 3)
    }

    @TestCase
    func testStructHost() {
        let s = ConfVarStruct()
        @Expect(s.take(3), 3)
    }

    @TestCase
    func testGenericStructHost() {
        let s = ConfVarGenS<Int64>()
        @Expect(s.pick(7), 7)
    }
}
