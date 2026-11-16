/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan CCC.m ok

interface III<T, U> {
    func m(): Unit
}

class CCC<M, N> {}

extend<P, Q> CCC<P, Q> <: III<P, III<Int32, Q>> {
    public func m(): Unit {
        println("CCC.m ok")
    }
}

func callIt(v: III<III<Int64, String>, III<Int32, String>>) {
    v.m()
}

main(): Int64 {
    callIt(CCC<III<Int64, String>, String>())
    return 0
}