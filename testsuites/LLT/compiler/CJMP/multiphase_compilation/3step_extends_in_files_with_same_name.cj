// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Each step adds an extend from a file named a.cj. Each extend must have a distinct name.
// Each step must retain the extend names from the CHIR of previous steps.

// SEPARATE-FILE: c/a.cj
// EXEC-0: %compiler %noColor --experimental c/a.cj --output-type=chir --output-dir ./c
package cmp

public interface I1 { func f1(): Int64 }

extend Int64 <: I1 { public func f1(): Int64 { 1 } }

public common func foo(): Int64

// SEPARATE-FILE: p1/a.cj
// EXEC-0: %compiler %noColor --experimental p1/a.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-dir=p1 --output-type=chir
package cmp

public interface I2 { func f2(): Int64 }

extend Int64 <: I2 { public func f2(): Int64 { 20 } }

public specific func foo(): Int64 { 300 }

public common func bar(): Int64

// SEPARATE-FILE: p2/a.cj
// EXEC-0: %compiler %noColor --experimental p2/a.cj --common-part-chir=p1/cmp.chir --common-part-cjo=./p1/cmp.cjo -o %output
// RUN: %run %output 2>&1 | compare %f
package cmp

public interface I3 { func f3(): Int64 }

extend Int64 <: I3 { public func f3(): Int64 { 4000 } }

public specific func bar(): Int64 { 50000 }

main() {
    println(1.f1() + 1.f2() + 1.f3() + foo() + bar())
}

/* SCAN
54321
*/
