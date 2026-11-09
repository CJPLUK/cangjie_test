// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py callee_param_invoke_static_local_must01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1I4callHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()
// ASSERT: scan InvokeStatic(

// Static dynamic dispatch (`InvokeStatic`): callee is still resolved through
// DynamicDispatch. `I.call` invokes abstract `I.use` with a non-copyable
// `C@local!` arg, so the call site inside `call` needs StartRegion.
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
    static func use(x: C@local!): Unit
    static func call(): Unit {
        use(C())
    }
}

class A <: I {
    public static func use(x: C@local!): Unit {
        println(x.x)
    }
}

main() {
    A.call()
}
