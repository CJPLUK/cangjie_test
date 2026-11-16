// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -o %output -Woff all 2>&1 | compare %f

class D {
    var v = 1
    init() {}
    init(this @local!) { exclave { v = 1 } }
}

class C {
    var d: D
    init() { d = D() }
    init(this @local!) { exclave { d = D() } }
}

func externalBaseReceivesInternal(pc: C@local!) {
    var d: D@local! = D()
    pc.d = d
}

func internalReceivesExternal(pc: C@local!) {
    var d: D@local! = D()
    d = pc.d
}

main() {}
/* SCAN
error: cannot assign internal @local! to expression of 'external Class-D @local!' type
  ==> assign_external_internal_message.cj:23:5:
   | 
23 |     pc.d = d
   |     ^^^^^^^^ 
   | 

error: cannot assign external @local! to expression of 'internal Class-D @local!' type
  ==> assign_external_internal_message.cj:28:5:
   | 
28 |     d = pc.d
   |     ^^^^^^^^ 
   | 

2 errors generated, 2 errors printed.
*/
