// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug %enableFuncInlining -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py inline_for01_CHIR/[0-9]*_FunctionInline.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

class C {
    init() {
        x = 3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

func make(): C@local! {
    exclave {
        return C()
    }
}

func use(): Int64 {
    let p = make()
    return p.x
}

main() {
    for (i in 0..3) {
        println(use())
    }
}
