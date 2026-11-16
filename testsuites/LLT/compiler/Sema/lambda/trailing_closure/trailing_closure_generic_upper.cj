// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

func test<T>(a: T) where T <: (Int64) -> Int64 {
    a(1)
}

main(): Int64 {
    return test {i => i}
}

/* SCAN
error: the upper bound '(Int64) -> Int64' of generic parameter 'Generics-T' must be class or interface
 ==> trailing_closure_generic_upper.cj:9:11:
  | 
9 | func test<T>(a: T) where T <: (Int64) -> Int64 {
  |           ^ 
  | 

error: trailing lambda cannot be used for non function nor option of function type
  ==> trailing_closure_generic_upper.cj:14:17:
   | 
14 |     return test {i => i}
   |                 ^^^^^^^^ declaration type of parameter: 'Generics-T'
   | 
note: found candidate
 ==> trailing_closure_generic_upper.cj:9:6:
  | 
9 | func test<T>(a: T) where T <: (Int64) -> Int64 {
  |      ^^^^ 
  | 

2 errors generated, 2 errors printed.
*/
