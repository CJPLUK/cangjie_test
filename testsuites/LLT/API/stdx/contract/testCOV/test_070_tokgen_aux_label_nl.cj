/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-070: an auxiliary contract variable used as a named-argument
// label with a line break before the colon must not be rewritten as a value read.
// The label scan skips the newlines between the identifier and the colon.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func tokAuxLabel(tokn!: Int64): Int64 {
    tokn
}

class CovTokAuxLabelHost {
    public init() {}

    @Contract [
        variable tokn: Int64 = 0
        ensures r: r >= 0
    ]
    public func compute(x: Int64): Int64 {
        tokAuxLabel(tokn
            : 1)
        x + 1
    }
}

@Test
class Test {
    @TestCase
    func testAuxLabelNewline() {
        @Expect(CovTokAuxLabelHost().compute(2), 3)
    }
}
