// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py callee_param_invoke_local_maybe_nodefault01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6callerHCNY_1IECNY_1CEQlE" | compare %f
// ASSERT: scan Invoke(
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()

// Virtual `Invoke` whose callee param is `C@local?` without a default.
// Passing an existing value must not open StartRegion in `caller` — only
// `local!`, or `local?` with a default-value function, forces a region via
// the callee-param check.
class C {
    init() {
        x = 3
    }
    exclave init(this @local?) {
        x = 7
    }
    var x: Int
}

interface I {
    func use(x: C@local?): Unit
}

class A <: I {
    public func use(x: C@local?): Unit {
        println(x.x)
    }
}

func caller(p: I, c: C@local?) {
    p.use(c)
}

main() {
    0
}
