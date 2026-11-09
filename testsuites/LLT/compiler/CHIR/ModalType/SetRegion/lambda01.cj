// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py lambda01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default3fooHCNY_1CEQlE" | compare %f
// ASSERT: scan-4 StartRegion()
// ASSERT: scan-4 EndRegion()

class C {
    init() {
        x =3
    }
    exclave init(this @local?) {
        x = 7
    }
    var x: Int
}

func foo(x: C@local?) {
    @local? func goo1() {
        @local? func goo2() {
            @local? func goo3() {
                println(x.x)
            }
            goo3()
        }
        goo2()
    }
    goo1()
}

main() {
    0
}