// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o getorthrow.out
// EXEC: %python pick_defination.py getorthrow_CHIR/[0-9]*_RedundantGetOrThrowElimination.chirtxt "Func @_CN7default3goo" | compare %f

// Repeated calls share their result until the Option value changes.
func goo(input: Option<Int64>): Int64 {
    var a = input
    try {
        let first = a.getOrThrow()
        let second = a.getOrThrow()
        a = Some(200)
        let third = a.getOrThrow()
        let fourth = a.getOrThrow()
        return first + second + third + fourth
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
// ASSERT: regex-after %(?P<first>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+, normal: #(?P<firstSuccess>\d+), exception: #\d+\)
// ASSERT: regex-after ^Block #(?P=firstSuccess):
// ASSERT: regex-after ^\s*GoTo\(#(?P<secondSuccess>\d+)\)
// ASSERT: regex-after ^Block #(?P=secondSuccess):\s+// predecessors: \[#(?P=firstSuccess)\]
// ASSERT: regex-after %(?P<third>\d+): Int64 = TryApply\(.*10getOrThrowHv, %\d+, normal: #(?P<thirdSuccess>\d+), exception: #\d+\)
// ASSERT: regex-after ^Block #(?P=thirdSuccess):
// ASSERT: regex-after ^\s*GoTo\(#(?P<fourthSuccess>\d+)\)
// ASSERT: regex-after ^Block #(?P=fourthSuccess):\s+// predecessors: \[#(?P=thirdSuccess)\]
// ASSERT: regex-after %(?P<sum1>\d+): Int64 = TryAdd\(%(?P=first), %(?P=first)[,)]
// ASSERT: regex-after %(?P<sum2>\d+): Int64 = TryAdd\(%(?P=sum1), %(?P=third)[,)]
// ASSERT: regex-after %(?P<sum3>\d+): Int64 = TryAdd\(%(?P=sum2), %(?P=third)[,)]
// ASSERT: regex-after %\d+: Unit = Store\(%(?P=sum3), %(?P=ret)\)
