/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-076: a directly annotated property accessor whose body
// hosts a local `@Contract` function inside a bare lambda expression statement
// and inside a bare `synchronized` statement. The accessor body scanner must
// recurse through both expression shapes to lower the deferred contracts.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*
import std.sync.*

class CovTokSyncLambdaHost {
    private var store: Int64 = 0

    public init() {}

    @Contract [
        get {
            ensures r: r >= 0
        }
        set {
            requires value >= 0
        }
    ]
    public mut prop amount: Int64 {
        get() {
            var acc = 0
            { =>
                @Contract [ ensures r: r >= 0 ]
                func lamInner(): Int64 {
                    8
                }
                lamInner()
            }
            let mtx = Mutex()
            synchronized (mtx) {
                @Contract [ ensures r: r >= 0 ]
                func syncInner(): Int64 {
                    2
                }
                acc = syncInner()
            }
            store + acc
        }
        set(v) {
            store = v
        }
    }
}

@Test
class Test {
    @TestCase
    func testSyncLambdaStatements() {
        let h = CovTokSyncLambdaHost()
        @Expect(h.amount, 2)
        h.amount = 5
        @Expect(h.amount, 7)
    }
}
