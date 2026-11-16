// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py ret_global_generic_local_must_copyable01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default6callerHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// Parameter is concrete `Int64`. Only the declared return type is generic
// `T @local!`, so the region is not opened by a `local!` parameter. Instantiation
// yields Copyable `Int64 @local!`.
func id<T>(n: Int64): T @local! {
    exclave {
        throw Exception()
    }
}

func caller() {
    try {
        let n: Int64 @local! = id<Int64>(1)
        println(n)
    } catch (e: Exception) {
        println(0)
    }
}

main() {
    caller()
}
