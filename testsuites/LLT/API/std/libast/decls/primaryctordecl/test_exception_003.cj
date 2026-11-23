/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %coverage_opt %cmp_opt_chir2hlir %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

internal import std.ast.*

main(): Int64 {
    var cnt = 0

    // Positive control: a single param list still constructs a primary
    // constructor node through both entry points.
    try {
        let p = PrimaryCtorDecl(quote(foo(let a: Int64) {}))
        if (p.identifier.value == "foo") {
            cnt++
        }
    } catch (_: Exception) {
        return -1
    }
    try {
        let p = parseDecl(quote(foo(let a: Int64) {}), astKind: "PrimaryCtorDecl")
        if (p.identifier.value == "foo") {
            cnt++
        }
    } catch (_: Exception) {
        return -1
    }

    // Negative: 'foo(let a: Int64)(b: Int64) {}' — a second (curried) param
    // list is not supported by the grammar. Neither entry point may silently
    // drop the trailing tokens; both must raise. The exact exception messages
    // are intentionally not checked here.
    try {
        parseDecl(quote(foo(let a: Int64)(b: Int64) {}), astKind: "PrimaryCtorDecl")
    } catch (_: Exception) {
        cnt++
    }

    try {
        PrimaryCtorDecl(quote(foo(let a: Int64)(b: Int64) {}))
    } catch (_: Exception) {
        cnt++
    }

    if (cnt != 4) {
        return -1
    }
    return 0
}
