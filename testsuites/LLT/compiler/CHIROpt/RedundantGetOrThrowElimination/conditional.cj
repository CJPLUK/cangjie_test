// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o getorthrow.out
// EXEC: %python pick_defination.py getorthrow_CHIR/[0-9]*_RedundantGetOrThrowElimination.chirtxt "Func @_CN7default3goo" | compare %f

func goo(cond: Bool) {
    var a = Some(100)

    if (cond) {
        let b2 = a.getOrThrow()
        var b3 = a.getOrThrow()
    }

    let b5 = a.getOrThrow()
    var b6 = a.getOrThrow()
}

main() {
    goo(true);
    0
}

// ASSERT: scan-2 10getOrThrowHv,
// ASSERT: regex-begin %(?P<first>\d+): Int64 = Apply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after %(?P<b3>\d+)\[b3\]: Int64& = Allocate\(Int64\)
// ASSERT: regex-after %\d+: Unit = Store\(%(?P=first), %(?P=b3)\)
// ASSERT: regex-after %(?P<second>\d+): Int64 = Apply\(.*10getOrThrowHv, %\d+[,)]
// ASSERT: regex-after %(?P<b6>\d+)\[b6\]: Int64& = Allocate\(Int64\)
// ASSERT: regex-after %\d+: Unit = Store\(%(?P=second), %(?P=b6)\)
