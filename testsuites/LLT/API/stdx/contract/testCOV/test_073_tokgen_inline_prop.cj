/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-073: a property annotated directly (no enclosing type
// contract) uses the inlined accessor shape: named setter result binding,
// exceptional `throws` catch wrapper, and deferred contracts of local functions
// declared in the accessor bodies (including lambda and synchronized blocks).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*
import std.sync.*

class TokInlineBiz <: Exception {
    init(message: String) {
        super(message)
    }
}

class CovTokInlineHost {
    private var store: Int64 = 0

    public init() {}

    @Contract [
        get {
            ensures r: r >= 0
        }
        set {
            requires value >= 0
            ensures r: true
            throws TokInlineBiz if value < 0
            ensures value >= 0
        }
    ]
    public mut prop amount: Int64 {
        get() {
            let viaLambda = { =>
                @Contract [ ensures r: r >= 0 ]
                func lambdaInner(): Int64 {
                    1
                }
                lambdaInner()
            }
            let mtx = Mutex()
            let viaSync = synchronized (mtx) {
                @Contract [ ensures r: r >= 0 ]
                func syncInner(): Int64 {
                    2
                }
                syncInner()
            }
            func outerNoContract(): Int64 {
                @Contract [ ensures r: r >= 0 ]
                func nestedInner(): Int64 {
                    3
                }
                nestedInner()
            }
            store + viaLambda() + viaSync + outerNoContract()
        }
        set(v) {
            @Contract [ requires true ]
            func setterInner(): Int64 {
                1
            }
            store = v + setterInner() - 1
        }
    }
}

@Test
class Test {
    @TestCase
    func testInlinePropertyContracts() {
        let h = CovTokInlineHost()
        @Expect(h.amount, 6)
        h.amount = 4
        @Expect(h.amount, 10)
    }
}
