// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

interface M {}
class C <: M {
    exclave init(this @local!) {}
}
class D <: M {
    exclave init(this @local!) {}
}
func foo(a: Int) {
    if (a < 0) {
        exclave { C() }
    }
    exclave { D() }
}

main() {}

/* SCAN
error: the return type of this function cannot be calculated from the function body and all the return and exclave expressions
  ==> multi_exclave_return_type_mismatch.cj:20:5:
   | 
20 |     exclave { D() }
   |     ^ 
   | 
   # note: Traces:
The types 'Class-C @local!' and 'Class-D @local!' do not have the smallest common supertype


1 error generated, 1 error printed.
*/
