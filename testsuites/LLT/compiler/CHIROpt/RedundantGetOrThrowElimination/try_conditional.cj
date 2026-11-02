// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o getorthrow.out
// EXEC: %python pick_defination.py getorthrow_CHIR/[0-9]*_RedundantGetOrThrowElimination.chirtxt "Func @_CN7default3goo" | compare %f

// A call in only one branch is unavailable after the branches join.
func goo(a: Option<Int64>, cond: Bool): Int64 {
    try {
        if (cond) {
            let first = a.getOrThrow()
            let second = a.getOrThrow()
        }
        let third = a.getOrThrow()
        let fourth = a.getOrThrow()
        return third + fourth
    } catch (e: Exception) {
        return -1
    }
}

main() {
    goo(Some(100), true)
    0
}

// ASSERT: scan-2 10getOrThrowHv,
// ASSERT: regex-begin \[ret\] %(?P<ret>\d+): Int64& = Allocate\(Int64\)
// ASSERT: regex-after %(?P<first>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after %(?P<third>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after %(?P<sum>\d+): Int64 = TryAdd\(%(?P=third), %(?P=third)[,)]
// ASSERT: regex-after %\d+: Unit = Store\(%(?P=sum), %(?P=ret)\)
