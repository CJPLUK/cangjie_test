/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-LOOP-015: `@loopInvariant` must decorate a for/while/do-while loop. The
// macro input below is an ordinary call expression, so the macro reports that
// the target is not a loop.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan loopInvariant input must be a for, while, or do-while expression
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

func loopNonLoopTarget(): Bool {
    true
}

@Contract
func loopNonLoop(): Int64 {
    @loopInvariant[true](loopNonLoopTarget())
    1
}

main() {
    loopNonLoop()
}
