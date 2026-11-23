/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-048: a function-level `variable` whose name matches a member of the
// enclosing type hijacks member references after the token rewrite (the body
// read the auxiliary slot instead of the field, audit report 2 #15). With a
// type-level `@Contract` present the clash must be diagnosed; the token
// rewriter cannot tell the two identifiers apart.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan collides with a member of the enclosing type
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract []
class NegAuxMemberClash {
    var x: Int64 = 5
    @Contract [variable x: Int64 = 0]
    public func f(): Int64 { x }
}

main() {
    println("unreachable")
}
