// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c
package cmp

public open class Base {}

public class Derived <: Base {}

public common class C {
    public init() {}
    public common func testFunc(x: Base): Base {
        println("common")
        x
    }
}

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %diag_json --experimental p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo -o %output 2>&1 | compare %f
// ASSERT: scan sema_not_matched
package cmp

public specific class C {
    public specific func testFunc(x: Derived): Derived {
        println("specific")
        x
    }
}

main(): Unit {
}
