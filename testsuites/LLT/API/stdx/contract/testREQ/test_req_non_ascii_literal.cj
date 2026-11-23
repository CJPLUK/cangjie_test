/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Non-ASCII (multi-byte) characters in a contract's string literals must not
// crash macro expansion. Every STRING_LITERAL is scanned while interpolation is
// rewritten; a byte slice that ends inside a UTF-8 character used to throw
// IllegalArgumentException and abort the whole compilation.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable limit: Int64 = 1
    requires "中文字面量".size > 0
    requires "前缀-${limit}-后缀".size > 0
    // Also contains `${` so escapeInterpolationText walks the multi-byte text
    // when it builds the failure message.
    requires x > 0 && "前缀-${limit}".size > 0
]
func checkChinese(x: Int64): Int64 {
    x
}

// The setter parameter is `v`, so the clause's `value` alias is rewritten by
// rewriteValueAlias while a Chinese literal is present in the same clause list.
@Contract
class ChineseBox {
    private var stored: Int64 = 0

    @Contract [
        set requires value >= 0
        set requires "中文标签".size > 0
    ]
    public mut prop content: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }
}

main() {
    if (checkChinese(2) != 2) {
        throw Exception("clause with Chinese literal should pass")
    }
    var caught = false
    try {
        checkChinese(0)
    } catch (e: ContractCheckRequiresException) {
        caught = true
        // The failing clause's Chinese literal must survive expansion verbatim.
        if (!e.message.contains("前缀")) {
            throw Exception("message mangled: " + e.message)
        }
    }
    if (!caught) {
        throw Exception("requires should have failed")
    }

    let box = ChineseBox()
    box.content = 5
    if (box.content != 5) {
        throw Exception("setter body should run")
    }
    caught = false
    try {
        box.content = -1
    } catch (e: ContractCheckRequiresException) {
        caught = true
    }
    if (!caught) {
        throw Exception("setter requires should have failed")
    }
    println("ok")
}
