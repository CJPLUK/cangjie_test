// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o getorthrow.out
// EXEC: %python pick_defination.py getorthrow_CHIR/[0-9]*_RedundantGetOrThrowElimination.chirtxt "Func @_CN7default3goo" | compare %f

// Finally is duplicated for the normal and exceptional paths. Only the normal
// copy can reuse the result of a successful call in the try body.
func goo(a: Option<Int64>): Int64 {
    try {
        let first = a.getOrThrow()
        let second = a.getOrThrow()
    } finally {
        let finalFirst = a.getOrThrow()
        let finalSecond = a.getOrThrow()
    }
    return 0
}

main() {
    goo(Some(100))
    0
}

// ASSERT: scan-2 10getOrThrowHv,
// ASSERT: regex-begin %(?P<first>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after ^Block #(?P<normal>\d+):
// ASSERT: regex-after ^\s*GoTo\(#(?P<next>\d+)\)
// ASSERT: regex-after ^Block #(?P=next):\s+// predecessors: \[#(?P=normal)\]
// ASSERT: regex-after %(?P<final>\d+): Int64 = Apply\(.*10getOrThrowHv, %\d+[,)]
