/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-081: contract generation for properties declared in an
// `extend` block: a settable property (setter alias rewrite) and a get-only
// property. Exercises the extend property/method contract processing path.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class VCovExtPropHost {
    public var stored: Int64 = 1
    public init() {}
}

@Contract []
extend VCovExtPropHost {
    @Contract [
        get ensures r: r >= 0
        set requires value > 0
    ]
    public mut prop scaled: Int64 {
        get() {
            stored * 2
        }
        set(v) {
            stored = v
        }
    }

    @Contract [
        get ensures r: r == stored + 1
    ]
    public prop bumped: Int64 {
        get() {
            stored + 1
        }
    }

    @Contract [
        requires n > 0
        ensures r: r == n
    ]
    public func identity(n: Int64): Int64 {
        n
    }

    public prop plain: Int64 {
        get() {
            5
        }
    }
}

@Test
class Test {
    @TestCase
    func testExtendProperty() {
        let host = VCovExtPropHost()
        @Expect(host.scaled, 2)
        @Expect(host.bumped, 2)
        host.scaled = 3
        @Expect(host.scaled, 6)
        @Expect(host.bumped, 4)
        @Expect(host.identity(5), 5)
        @Expect(host.plain, 5)
    }
}
