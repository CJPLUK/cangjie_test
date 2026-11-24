/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-027: the same class-level auxiliary variable contributed by two
// unrelated parents with an identical declaration is merged (storage emitted
// once) instead of being reported as a conflict.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable shared: Int64 = 0
]
interface MergeBaseA {}

@Contract [
    variable shared: Int64 = 0
]
interface MergeBaseB {}

@Contract [
    inherits from MergeBaseA
    inherits from MergeBaseB
]
class MergeChild <: MergeBaseA & MergeBaseB {
    public init() {}
}

@Test
class Test {
    @TestCase
    func testMerge() {
        let c = MergeChild()
        @Expect(c.shared, 0)
    }
}
