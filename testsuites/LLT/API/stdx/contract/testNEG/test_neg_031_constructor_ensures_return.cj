/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-031: constructors return no value, so an `ensures` return binding
// (`ensures ret: expr`) has nothing to bind. The contract macro rejects it with
// a targeted diagnostic instead of generating a meaningless `let ret = ()`
// binding whose type error points at unrelated code.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `ensures` return binding is not supported on constructor contracts
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
class Neg031CtorEnsuresRet {
    public var amount: Int64 = 0

    @Contract[
        ensures ret: amount > 0
    ]
    public init(a: Int64) {
        amount = a
    }
}

main() {
}
