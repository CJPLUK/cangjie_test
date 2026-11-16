// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c 2>&1 | compare %f
package cmp
public abstract class A{
    public prop a: Int32 // the only correct form
    public common prop b: Int32
    public abstract prop c: Int32
    public common abstract prop d: Int32
}

/* SCAN
error: property b is common, but class is not common
 ==> c/c.cj:5:5:
  | 
5 |     public common prop b: Int32
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
  | 

error: unexpected modifier 'abstract' on property declaration in class body
 ==> c/c.cj:6:12:
  | 
3 | public abstract class A{
  |                 ~~~~~ in class
4 |     public prop a: Int32 // the only correct form
  | ...
6 |     public abstract prop c: Int32
  |     ~~~~   ^^^^^^^^ unexpected modifier
  |     |
  |     on property declaration
  | 

error: only common/specific or '@Java' foreign abstract classes can have explicitly abstract property
 ==> c/c.cj:6:34:
  | 
6 |     public abstract prop c: Int32
  |                                  ^ 
  | 

error: property d is common, but class is not common
 ==> c/c.cj:7:5:
  | 
7 |     public common abstract prop d: Int32
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
  | 

error: unexpected modifier 'abstract' on property declaration in class body
 ==> c/c.cj:7:19:
  | 
3 | public abstract class A{
  |                 ~~~~~ in class
4 |     public prop a: Int32 // the only correct form
  | ...
7 |     public common abstract prop d: Int32
  |     ~~~~          ^^^^^^^^ unexpected modifier
  |     |
  |     on property declaration
  | 

5 errors generated, 5 errors printed.
*/
