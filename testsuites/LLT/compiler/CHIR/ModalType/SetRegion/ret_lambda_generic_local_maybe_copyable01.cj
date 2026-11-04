// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py ret_lambda_generic_local_maybe_copyable01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default4hostHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// Lambda return type is `T @local?`. `host` instantiates the call to Copyable `Int64 @local?`.
func caller<T>(x: T): T @local? {
    let id: (T) -> T @local? = { y: T => exclave { y } }
    exclave {
        id(x)
    }
}

func host() {
    let b: Int64 @local? = caller(1)
    println(b)
}

main() {
    host()
}
