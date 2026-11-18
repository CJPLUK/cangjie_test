/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-052: `inherits invariant <type>.<name>` with a lowercase last
// segment. The type-name heuristic used to require the final segment to start
// uppercase, so references to lowercase parent type names (and lowercase type
// parameters) were rejected (audit report 2 #30).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [invariant [I1] true]
open class inhLowerBase {
    public init() {}
}

@Contract [inherits invariant inhLowerBase.I1]
class InhLowerChild <: inhLowerBase {}

main() {
    let c = InhLowerChild()
    println("ok")
}
