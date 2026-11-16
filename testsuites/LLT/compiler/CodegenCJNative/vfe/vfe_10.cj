/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// ERRCHECK: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// ASSERT: scan expected 'Interface-III<Interface-III<Class-RRR, Struct-String>, Struct-String>', found 'Class-CCC<Struct-String, Struct-String>'

open class RRR {}
open class SSS <: RRR {}

interface III<T, U> {
    func m(): Unit
}

open class BBB<M, N> <: III<III<SSS, M>, N> {
    public func m(): Unit {
        println("BBB.m ok")
    }
}

class CCC<P, Q> <: BBB<P, Q> {}


func callIt(v: III<III<RRR, String>, String>) {
    v.m()
}

main(): Int64 {
    callIt(CCC<String, String>())
    return 0
}