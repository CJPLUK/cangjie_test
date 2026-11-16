// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py callee_param_local_maybe_nodefault01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default3fooHCNY_1CEQlE" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()

// Callee param is `C@local?` but has no default. Passing an existing value must
// not open StartRegion in `foo` — only `local!`, or `local?` with a
// default-value function, forces a region via the callee-param check.
class C {
    init() {
        x = 3
    }
    exclave init(this @local?) {
        x = 7
    }
    var x: Int
}

func bar(x: C@local?) {
    println(x.x)
}

func foo(x: C@local?) {
    bar(x)
}

main() {
    0
}
