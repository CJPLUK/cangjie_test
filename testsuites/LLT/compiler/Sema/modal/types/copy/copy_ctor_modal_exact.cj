// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Copyable without a @local! ctor: both inferred and annotated targets reject
// S()@local! (RemoveMismatchedThisModeForCtorCall has no copy exemption).
// S() without postfix modal still converts via copy mode erasure.

// ERRCHECK: %compiler %local %f %cmp_opt -Woff all 2>&1

struct S <: Copyable {
    let a = 1
    init() {}
}

func f() {
    let s1 = S()@local!
    let s2: S@local! = S()@local!
    let s3: S@local! = S()
}

main() { 0 }
/* SCAN
error: no matching constructor for call 'S'
  ==> copy_ctor_modal_exact.cj:19:14:
   | 
19 |     let s1 = S()@local!
   |              ^ 
   | 

error: no matching constructor for call 'S'
  ==> copy_ctor_modal_exact.cj:20:24:
   | 
20 |     let s2: S@local! = S()@local!
   |                        ^ 
   | 

2 errors generated, 2 errors printed.
*/
