// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py callee_param_invoke_local_must01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6callerHCNY_1IE" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()
// ASSERT: scan Invoke(

// Instance virtual call (`Invoke`): callee is resolved through DynamicDispatch.
// Abstract/open methods cannot carry optional params, so this uses a
// non-copyable `C@local!` formal — `caller` needs StartRegion for that Invoke.
// The same body also constructs `C()` (exclave init `this @local!`), which
// likewise requires a region; the Invoke line is what guards the dispatch path.
class C {
    init() {
        x = 3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

interface I {
    func use(x: C@local!): Unit
}

class A <: I {
    public func use(x: C@local!): Unit {
        println(x.x)
    }
}

func caller(p: I) {
    p.use(C())
}

main() {
    let p: I = A()
    caller(p)
}
