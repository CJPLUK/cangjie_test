// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %n.cj -o %n.%suffix 2>&1 | compare %f

open class A {
    public mut open prop i: Int64 {
        get() {
            return 0
        }
        set(v) {}
    }
}

interface B {
    mut prop i: Int32
}

class C <: A & B {
    public mut override prop i: Int64 {
        get() {
            return 1
        }
        set(v) {}
    }
}

open class A1 {
    public mut open prop i: String {
        get() {
            return "0"
        }
        set(v) {}
    }
}

interface B1 {
    mut prop i: Int64
}

class C1 <: A1 & B1 {
    public mut override prop i: Int64 {
        get() {
            return 1
        }
        set(v) {}
    }
}
main() {}

/* SCAN
error: overloaded instance property must be of the same data type
  ==> property9.cj:23:30:
   | 
23 |     public mut override prop i: Int64 {
   |                              ^ 
   | 
note: 'i' is previously declared here
  ==> property9.cj:19:14:
   | 
19 |     mut prop i: Int32
   |              ^ 
   | 

error: class 'C' missing abstract modifier, otherwise abstract function or property should be implemented
  ==> property9.cj:22:1:
   | 
22 |   class C <: A & B {
   |  _^
23 | |     public mut override prop i: Int64 {
   | | ...
29 | | }
   | |_^
   | 
note: unimplemented interface property 'i'
  ==> property9.cj:19:5:
   | 
19 |     mut prop i: Int32
   |     ^^^^^^^^^^^^^^^^^ 
   | 

error: overloaded instance property must be of the same data type
  ==> property9.cj:45:30:
   | 
45 |     public mut override prop i: Int64 {
   |                              ^ 
   | 
note: 'i' is previously declared here
  ==> property9.cj:32:26:
   | 
32 |     public mut open prop i: String {
   |                          ^ 
   | 

error: overloaded instance property must be of the same data type
  ==> property9.cj:32:26:
   | 
32 |     public mut open prop i: String {
   |                          ^ 
   | 
note: 'i' is previously declared here
  ==> property9.cj:41:14:
   | 
41 |     mut prop i: Int64
   |              ^ 
   | 

error: type of the inherited property members 'i' are not identical and not in subtype relation
  ==> property9.cj:44:7:
   | 
44 | class C1 <: A1 & B1 {
   |       ^^ 
   | 
   # note: conflict types are 'Int64', 'Struct-String'

5 errors generated, 5 errors printed.
*/
