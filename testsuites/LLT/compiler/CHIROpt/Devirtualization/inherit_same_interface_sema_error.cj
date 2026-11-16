// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %cmp_opt %enableDevirtualization -Woff all %f -o %n.%suffix 2>&1 | compare %f


interface I1 {
    func f1(a: Int64): Unit {
        println("I")
    }
}

interface I2 <: I1 {
    func f1(a: Int64): Unit {
        println("I2 f1")
    }
}

interface I3 <: I2 {}

open class A {}

open class A1 <: A & I2 & I3 {}

func Test(i1: I1) {
    i1.f1(1)
}

func Test1(i2: I2) {
    i2.f1(1)
}

func Test2(i3: I3) {
    i3.f1(1)
}

main() {
    Test1(A1())
    Test2(A1())
    Test(A1())
}

/* SCAN-IN
error: interface function 'f1(a: Int64): Unit' must be implemented in 'A1'
  ==> inherit_same_interface_sema_error.cj:27:1:
   | 
27 | open class A1 <: A & I2 & I3 {}
   | ^ 
   | 

1 error generated, 1 error printed.
*/
