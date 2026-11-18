/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-REQ-003: backslash escape sequences in a clause's source text must appear
// verbatim in the failure message (`\n` must not become a real newline, `\\`
// must not collapse). Fixed (audit report 3, R4): `escapeInterpolationText`
// only escaped `${`, so the generated string literal re-interpreted the
// backslashes.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    requires "a\\nb".size > 100
]
func slashy(): Unit {}

main() {
    try {
        slashy()
        throw Exception("requires should have failed")
    } catch (e: ContractCheckRequiresException) {
        // The message must be byte-for-byte identical to the clause source.
        if (e.message != "requires \"a\\\\nb\".size > 100") {
            throw Exception("message mangled: " + e.message)
        }
        println("ok")
    }
}
