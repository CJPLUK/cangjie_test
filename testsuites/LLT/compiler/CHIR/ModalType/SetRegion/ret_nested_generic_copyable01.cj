// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py ret_nested_generic_copyable01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6callerHv" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()

// Nested generic returns `T`, instantiated to Copyable `Int64`.
func caller() {
    func id<T>(x: T): T {
        x
    }
    let n = id(1)
    println(n)
}

main() {
    caller()
}
