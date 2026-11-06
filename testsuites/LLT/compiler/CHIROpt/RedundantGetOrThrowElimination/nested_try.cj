// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o getorthrow.out
// EXEC: %python pick_defination.py getorthrow_CHIR/[0-9]*_RedundantGetOrThrowElimination.chirtxt "Func @_CN7default3goo" | compare %f

// The inner catch is still inside the outer try, so its calls are TryApply.
// It must not reuse a result from the failed inner try.
func goo(a: Option<Int64>): Int64 {
    try {
        try {
            let first = a.getOrThrow()
            let second = a.getOrThrow()
            return second
        } catch (e: Exception) {
            let caught = a.getOrThrow()
            let repeated = a.getOrThrow()
            return repeated
        }
    } catch (e: Exception) {
        return -1
    }
}

main() {
    goo(Some(100))
    0
}

// ASSERT: scan-2 10getOrThrowHv,
// ASSERT: regex-begin \[ret\] %(?P<ret>\d+): Int64& = Allocate\(Int64\)
// ASSERT: regex-after %(?P<first>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after %\d+: Unit = Store\(%(?P=first), %(?P=ret)\)
// ASSERT: regex-after %(?P<caught>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after %\d+: Unit = Store\(%(?P=caught), %(?P=ret)\)
