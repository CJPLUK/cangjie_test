// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: c/c.cj
// EXEC-PIPE-1: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c 2>&1 | compare %f
package cmp

abstract class AAA {
    // class is not common, so abstract modifier is not allowed
    public abstract func foo() { 1 }
}

/* SCAN
error: only common/specific or '@Java' foreign abstract classes can have explicitly abstract function
 ==> c/c.cj:6:5:
  | 
6 |     public abstract func foo() { 1 }
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
  | 

1 error generated, 1 error printed.
*/
