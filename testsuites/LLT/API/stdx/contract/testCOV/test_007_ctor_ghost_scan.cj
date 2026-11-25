/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-007: a constructor whose body declares in-body contract macros
// (@ghost / @contractAssert / @loopInvariant) with an early top-level
// return, plus a local contract nested inside a spawn lambda.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable total: Int64 = 0
    invariant total >= 0
]
class CtorGhostScan {
    public init(n: Int64) {
        @ghost ( total = n )
        @contractAssert ( n >= 0 )
        @loopInvariant[total >= 0](for (i in 0..n) {
            ()
        })
        if (n < 0) {
            return
        }
    }

    public func read(): Int64 {
        total
    }
}

@Contract [ invariant ok >= 0 ]
class SpawnLocalHost {
    public var ok: Int64 = 0
    public init() {}

    public func demo(n: Int64): Int64 {
        spawn { =>
            @Contract [ requires x > 0 ]
            func inSpawn(x: Int64): Int64 {
                x + 1
            }
            ok = inSpawn(n)
        }
        n
    }
}

@Test
class Test {
    @TestCase
    func testCtorGhostScan() {
        let c = CtorGhostScan(3)
        @Expect(c.read(), 3)
        var threw = false
        try {
            CtorGhostScan(-1)
        } catch (e: ContractCheckInvariantException) {
            threw = true
        }
        @Expect(threw, true)
    }

    @TestCase
    func testSpawnLocal() {
        let h = SpawnLocalHost()
        @Expect(h.demo(2), 2)
    }
}
