// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c
package cmp

public common interface I {
    common func foo6(): Unit { println("I::foo6 common") }
}

public common interface I3 {}

public open class A <: I & I3 {}

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %noColor --experimental p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-type=dylib --output-dir ./p 2>&1 | compare %f
package cmp

public specific interface I {
}

public specific interface I3 {
    func foo6(): Unit { println("I3::foo specific") }
} 

/* SCAN
error: interface function 'foo6(): Unit' must be implemented in 'A'
  ==> (package cmp)c.cj:19:1:

1 error generated, 1 error printed.
*/