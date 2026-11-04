// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py exclave_default_param01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// `wrap` itself is not exclave; it only consumes `C@local!`. Calling `wrap()`
// materializes the default via desugared `y.0` (returns `C@local!`, calls
// exclave `makeC`). `main` and `y.0` each open a region; `wrap` does not.
// Run as well so the pairing still executes.
class C {
    init() {
        x = 3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

exclave func makeC(): C@local! {
    C()
}

func wrap(y!: C@local! = makeC()) {
    println(y.x)
}

main() {
    wrap()
}
