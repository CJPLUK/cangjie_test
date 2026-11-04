// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py ret_nested_generic_local_maybe_copyable01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6callerHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// Nested generic returns `T @local?`. The call instantiates `T` to Copyable `Int64`.
func caller() {
    func id<T>(x: T): T @local? {
        exclave {
            x
        }
    }
    let n: Int64 @local? = id(1)
    println(n)
}

main() {
    caller()
}
