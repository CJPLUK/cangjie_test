// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py global_func03_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1gHv" | compare %f
// ASSERT: scan StartRegion()
// ASSERT: scan EndRegion()

exclave func f<T>(x: T@local!): Unit {
    let p: String @local! ="hello"
    let a = Array<String>(1000, repeat: p) @local!
}
func g() {
    f(5)
}
main() {
    g()
}