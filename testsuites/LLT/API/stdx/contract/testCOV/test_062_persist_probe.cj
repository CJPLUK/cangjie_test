/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-062: with CANGJIE_STDX_CONTRACT_META_DIR unset, the default write
// directory is `<cwd>/target/contract_meta` and the cjpm module rooted at the
// working directory is probed: its own meta directory plus the `target/contract_meta`
// of every `path` dependency declared in cjpm.toml are appended as read-only
// search locations. The cjpm.toml below is parsed line by line, so it also
// exercises the TOML helpers (`path` key detection, quoting, malformed lines).
// EXEC: mkdir -p target/contract_meta dep/target/contract_meta other/target/contract_meta
// EXEC: printf '%s\n' '# a comment' '[package]' 'name = "cov"' 'classpath = "no-path-key"' '[dependencies]' 'dep = { path = "./dep" }' 'single = { path = '\''./other'\'' }' 'noeq = { path "./dep" }' 'raw = { path = ./raw }' 'unterminated = { path = "./dep' 'spaced = {path=   "./dep"}' 'abs = { path = "/tmp/cov_abs_dep" }' 'win = { path = "C:/cov_win_dep" }' 'patx = 1' 'xclasspath = "zz"' 'dirtrail = { path = "./dep/" }' 'x' 'path = "./dep"' '[test-dependencies]' 'dep2 = { path = "./other" }' '[build]' 'ignored = { path = "./dep" }' > cjpm.toml
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=Z:/cov_drive_meta %compiler %import-cangjie-stdx %cmp_opt -o %n.drive.%suffix %f %cmp_utest_opt
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_trail_meta/ %compiler %import-cangjie-stdx %cmp_opt -o %n.trail.%suffix %f %cmp_utest_opt
// EXEC: truncate -s 17M cjpm.toml
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.huge.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [
    invariant [nonNegative] total >= 0
]
open class CovPersistProbeBase {
    public var total: Int64 = 0

    public init() {}

    @Contract [
        requires d >= 0
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}

@Contract [
    inherits from CovPersistProbeBase
]
class CovPersistProbeChild <: CovPersistProbeBase {
    public init() {
        super()
    }

    public override func add(d: Int64): Unit {
        total += d * 2
    }
}

@Test
class Test {
    @TestCase
    func inheritedRequiresBlocksNegative() {
        let c = CovPersistProbeChild()
        var blocked = false
        try {
            c.add(-1)
        } catch (e: ContractCheckRequiresException) {
            blocked = true
        }
        @Expect(blocked, true)
    }

    @TestCase
    func validCallRuns() {
        let c = CovPersistProbeChild()
        c.add(3)
        @Expect(c.total, 6)
    }
}
