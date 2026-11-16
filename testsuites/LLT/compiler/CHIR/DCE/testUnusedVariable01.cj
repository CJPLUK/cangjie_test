// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// (CJNATIVE) EXEC-PIPE-0: %run %run_opt %output %run_args

public func foo() {
    let a = 1
    0
}

public func foo1() {
    var a = 2
    0
}

public func foo2() {
    for (i in 0..3) {
    }
    0
}

public func foo3() {
    var (a, b) = (1, 2)
    0
}

public func foo4() {
    var a = Option<Int64>.Some(11)
    match (a) {
        case Some(v) => println(1)
        case _ => println(0)
    }
    0
}

public func foo5() {
    var a: (Int64) -> Int64 = {i => 1}
    0
}

public func foo6() {
    var a = Option<Int64>.Some(11)
    match (a) {
        case Some(v) where v > 10 => println(1)
        case _ => println(0)
    }
    0
}

public func foo7() {
    var a = Option<Int64>.Some(11)
    var b = 1
    match (a) {
        case Some(v) where b < 10 => println(1)
        case _ => println(0)
    }
    0
}

public func foo8() {
    var a = Option<Int64>.Some(11)
    var b = 1
    match (a) {
        case Some(v) where b < 10 => println(v)
        case _ => println(0)
    }
    0
}

public func foo9() {
    for (i in 0..3) {
        return i
    }
    0
}

public func foo10(endIndex: Int64, end: String): Int64 {
    var i = 0
    for (aaaa in end where i < endIndex) {
        println(aaaa)
        i++
    }
    return i
}

main() {
    foo() + foo1() + foo2() + foo3() + foo4() + foo5() + foo6() + foo7() + foo8() + foo9() + foo10(1, "abcd")
    return 0
}

/* SCAN
warning: unused variable:'a'
  ==> testUnusedVariable01.cj:11:9:
   | 
11 |     let a = 1
   |         ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'a'
  ==> testUnusedVariable01.cj:16:9:
   | 
16 |     var a = 2
   |         ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'i'
  ==> testUnusedVariable01.cj:21:10:
   | 
21 |     for (i in 0..3) {
   |          ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'a'
  ==> testUnusedVariable01.cj:27:10:
   | 
27 |     var (a, b) = (1, 2)
   |          ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'b'
  ==> testUnusedVariable01.cj:27:13:
   | 
27 |     var (a, b) = (1, 2)
   |             ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unreachable pattern
  ==> testUnusedVariable01.cj:35:14:
   | 
35 |         case _ => println(0)
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'a'
  ==> testUnusedVariable01.cj:41:9:
   | 
41 |     var a: (Int64) -> Int64 = {i => 1}
   |         ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unused variable:'i'
  ==> testUnusedVariable01.cj:41:32:
   | 
41 |     var a: (Int64) -> Int64 = {i => 1}
   |                                ^ unused variable
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unreachable pattern
  ==> testUnusedVariable01.cj:59:14:
   | 
59 |         case _ => println(0)
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

warning: unreachable pattern
  ==> testUnusedVariable01.cj:69:14:
   | 
69 |         case _ => println(0)
   |              ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

10 warnings generated, 10 warnings printed.
*/

// Enum payload constants are not propagated yet, so foo6 does not diagnose its fallback after the guard.
