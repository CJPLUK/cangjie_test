/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// A constructor contract that needs `$pre` snapshots splits the body into a
// checked branch and a disabled branch. The disabled branch is reassembled from
// the original statements, whose tokens carry no trailing statement separator;
// without an explicit NL the concatenated statements re-parse as one malformed
// expression and macro expansion fails with ParseASTException. A constructor
// body with two or more statements must still compile.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract[]
class EnsPreMultiStmt {
    var a: Int64
    var b: Int64

    @Contract [
        ensures a == $pre(x)
    ]
    init(x: Int64) {
        a = x
        b = x + 1
    }
}

@Contract[]
class EnsPreMultiStmtFail {
    var a: Int64
    var b: Int64

    @Contract [
        ensures a == $pre(x)
    ]
    init(x: Int64) {
        a = x + 1
        b = x + 2
    }
}

main() {
    let ok = EnsPreMultiStmt(4)
    if (ok.a != 4 || ok.b != 5) {
        throw Exception("constructor body should run")
    }
    var caught = false
    try {
        EnsPreMultiStmtFail(4)
    } catch (e: ContractCheckEnsuresException) {
        caught = true
    }
    if (!caught) {
        throw Exception("ensures should have failed")
    }
    println("ok")
}
