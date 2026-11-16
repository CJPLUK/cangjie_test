/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan-begin A.m ok
// ASSERT: scan-next Box.m ok

interface I<T, U> {
    func m(): Unit
}

class Box<T> {
    public let v: T
    
    public init(v: T) {
        this.v = v
    }
}

extend<T> Box<T> <: I<T, Int64> { // 通配符在第一位！
    public func m(): Unit {
        println("Box.m ok")
    }
}

class A <: I<String, Int64> {
    public func m(): Unit {
        println("A.m ok")
    }
}

func callIt(v: I<String, Int64>) {
    v.m()
}

main(): Int64 {
    callIt(A())
    callIt(Box<String>("x"))
    0
}