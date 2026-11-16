// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py exclave01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default3fooHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-2 EndRegion()
// ASSERT: scan-begin EndRegion()
// ASSERT: scan-next GoTo(

// Same function body first does a local allocation / local-param call (so the body
// itself opens a region) and then `exclave return`. FlattenExclave replaces Exclave
// with GoTo, so EndRegion must appear immediately before that GoTo into the exclave
// sub-block.
class C {
    init() {
        x = 3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

exclave func consume<T>(x: T@local!): Unit {
    let p: String@local! = "hello"
    println(p)
}

func foo(): C@local! {
    let s: String@local! = "hello"
    consume(s)
    exclave {
        return C()
    }
}

main() {
    let p = foo()
    println(p.x)
}
