// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

package javaapp.my


import java.lang.JObject
import std.unittest.assertEqual
import std.unittest.testmacro.Assert

@Java
open foreign class M {
    init()
}

@Java
class A <: M {
    A() {
        super()
    }
}

class CJClass {}

func testIf(m: Option<JObject>, n: Int64) {
    let r = if (true && let Some(o : A) <- m && true) {
        1
    } else if (let Some(o : A) <- m) {
        2
    } else {
        3
    }
    @Assert(r == n)
}

func testWhile(m: Option<JObject>, n: Int64) {
    var r = 1
    while (let Some(o : A) <- m) {
        r = 2
        break
    }
    @Assert(r == n)
}

/**
 * Test note: let patterns are not yet supported
 */

/* SCAN-IN
error: Java interoperability feature 'let type patterns with JavaImpl or JavaMirror types' is not yet supported
  ==> let_pattern.cj:25:34:
   | 
25 |     let r = if (true && let Some(o : A) <- m && true) {
   |                                  ^^^^^ 
   | 

error: Java interoperability feature 'let type patterns with JavaImpl or JavaMirror types' is not yet supported
  ==> let_pattern.cj:27:25:
   | 
27 |     } else if (let Some(o : A) <- m) {
   |                         ^^^^^ 
   | 

error: Java interoperability feature 'let type patterns with JavaImpl or JavaMirror types' is not yet supported
  ==> let_pattern.cj:37:21:
   | 
37 |     while (let Some(o : A) <- m) {
   |                     ^^^^^ 
   | 

3 errors generated, 3 errors printed.
*/
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
