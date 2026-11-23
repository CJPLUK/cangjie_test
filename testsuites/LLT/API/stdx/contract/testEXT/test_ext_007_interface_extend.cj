/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-EXT-007 (language-level negative, NOT a contract case): design expects
// interface-default-member contracts checked via `extend <interface>`, but the
// language rejects extending an interface type outright. This case records the
// language rule only; it declares no `@Contract` and does not exercise contract
// inheritance. Contract-covered extend cases live in the other test_ext_* files
// (e.g. test_ext_010_extend_inherits_from.cj).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan extending type 'Interface-Printable' is not allowed
// ASSERT: scan-not core dumped

interface Printable {
    func printIt(): Unit
}

extend Printable {
    public func printIt(): Unit {}
}

main() {
}
