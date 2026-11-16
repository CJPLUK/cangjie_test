/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan AAA<P, Q>::foo

private interface III<M, N> {
    func foo():Unit {
        println("III<M, N>::foo")
    }

    func goo():Unit {
        println("III<M, N>::goo")
    }
}

class AAA<P, Q> <: III<P, Q> {
    public func foo():Unit {
        println("AAA<P, Q>::foo")
    }

    public func goo():Unit {
        println("AAA<P, Q>::goo")
    }
}


private func moo<T, G>(iii:III<T, G>) {
    iii.foo()
}

main(): Unit {
    moo(AAA<Int32, Int8>())
}
