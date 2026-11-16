// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py ret_lambda_generic_copyable01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default4hostHv" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()

// Lambda inside a generic function returns `T`. `host` instantiates it to Copyable `Int64`.
func caller<T>(x: T): T {
    let id = { y: T => y }
    id(x)
}

func host() {
    let a = caller(1)
    println(a)
}

main() {
    host()
}
