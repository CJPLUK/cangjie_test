// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -o %output
// EXEC: %python pick_defination.py global_func02_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// ASSERT: scan StartRegion()
// ASSERT: scan EndRegion()

class C {
    init() {
        x =3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

main() {
    unsafe {
        let p = zeroValue2<C>()
        println(p.x)
    }
}