// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: c/c.cj
// EXEC-PIPE-1: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c --error-count-limit=20 2>&1 | compare %f
package cmp

public common interface I0 {
    abstract func f1(): Unit
    abstract func f2(): Unit {}
    common abstract func f3(): Unit
    common abstract func f4(): Unit {}
    abstract static func f5(): Unit
    abstract static func f6(): Unit {}
    common abstract static func f7(): Unit
    common abstract static func f8(): Unit {}
}

/* SCAN
error: unexpected modifier 'abstract' on function declaration in interface body
 ==> c/c.cj:5:5:
  | 
4 | public common interface I0 {
  |               ~~~~~~~~~ in interface
5 |     abstract func f1(): Unit
  |     ^^^^^^^^ ~~~~ on function declaration
  |     |
  |     unexpected modifier
  | 

error: only common/specific or '@Java' foreign abstract classes can have explicitly abstract function
 ==> c/c.cj:5:5:
  | 
5 |     abstract func f1(): Unit
  |     ^^^^^^^^^^^^^^^^^^^^^^^^ 
  | 

error: unexpected modifier 'abstract' on function declaration in interface body
 ==> c/c.cj:6:5:
  | 
4 | public common interface I0 {
  |               ~~~~~~~~~ in interface
5 |     abstract func f1(): Unit
6 |     abstract func f2(): Unit {}
  |     ^^^^^^^^ ~~~~ on function declaration
  |     |
  |     unexpected modifier
  | 

error: only common/specific or '@Java' foreign abstract classes can have explicitly abstract function
 ==> c/c.cj:6:5:
  | 
6 |     abstract func f2(): Unit {}
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
  | 

error: unexpected modifier 'abstract' on function declaration in interface body
 ==> c/c.cj:7:12:
  | 
4 | public common interface I0 {
  |               ~~~~~~~~~ in interface
5 |     abstract func f1(): Unit
  | ...
7 |     common abstract func f3(): Unit
  |            ^^^^^^^^ ~~~~ on function declaration
  |            |
  |            unexpected modifier
  | 

error: unexpected modifier 'abstract' on function declaration in interface body
 ==> c/c.cj:8:12:
  | 
4 | public common interface I0 {
  |               ~~~~~~~~~ in interface
5 |     abstract func f1(): Unit
  | ...
8 |     common abstract func f4(): Unit {}
  |            ^^^^^^^^ ~~~~ on function declaration
  |            |
  |            unexpected modifier
  | 

error: unexpected modifier 'abstract' on function declaration in interface body
 ==> c/c.cj:9:5:
  | 
4 | public common interface I0 {
  |               ~~~~~~~~~ in interface
5 |     abstract func f1(): Unit
  | ...
9 |     abstract static func f5(): Unit
  |     ^^^^^^^^        ~~~~ on function declaration
  |     |
  |     unexpected modifier
  | 

error: only common/specific or '@Java' foreign abstract classes can have explicitly abstract function
 ==> c/c.cj:9:5:
  | 
9 |     abstract static func f5(): Unit
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
  | 

error: unexpected modifier 'abstract' on function declaration in interface body
  ==> c/c.cj:10:5:
   | 
4  | public common interface I0 {
   |               ~~~~~~~~~ in interface
5  |     abstract func f1(): Unit
   | ...
10 |     abstract static func f6(): Unit {}
   |     ^^^^^^^^        ~~~~ on function declaration
   |     |
   |     unexpected modifier
   | 

error: only common/specific or '@Java' foreign abstract classes can have explicitly abstract function
  ==> c/c.cj:10:5:
   | 
10 |     abstract static func f6(): Unit {}
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
   | 

error: unexpected modifier 'abstract' on function declaration in interface body
  ==> c/c.cj:11:12:
   | 
4  | public common interface I0 {
   |               ~~~~~~~~~ in interface
5  |     abstract func f1(): Unit
   | ...
11 |     common abstract static func f7(): Unit
   |            ^^^^^^^^        ~~~~ on function declaration
   |            |
   |            unexpected modifier
   | 

error: unexpected modifier 'abstract' on function declaration in interface body
  ==> c/c.cj:12:12:
   | 
4  | public common interface I0 {
   |               ~~~~~~~~~ in interface
5  |     abstract func f1(): Unit
   | ...
12 |     common abstract static func f8(): Unit {}
   |            ^^^^^^^^        ~~~~ on function declaration
   |            |
   |            unexpected modifier
   | 

12 errors generated, 12 errors printed.
*/
