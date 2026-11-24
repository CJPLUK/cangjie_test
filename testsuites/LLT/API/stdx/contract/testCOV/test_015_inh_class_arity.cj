/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-015: a declared generic parent instantiated with the wrong number of
// type arguments is reported while merging class-level variables and parent
// member attributes.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan wrong number of type arguments for `ArityBase`
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract []
open class ArityBase<T> {
    public init() {}
}

@Contract []
class ArityChild <: ArityBase<Int64, Int64> {
    public init() {}
}

main(): Int64 {
    0
}
