// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c
package cmp

common func foo(): Unit{}

common class A0 {
    common func foo(): Unit{}
    init() {}
}

common class A1 {
    common func foo(): Unit{}
    init() {}
}

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %diag_json --experimental p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-type=dylib --output-dir ./p 2>&1 | compare %f
// ASSERT: scan-2 sema_not_matched
// ASSERT: scan-1 sema_generic_member_type_argument_different
// ASSERT: scan-1 'specific' class 'A1' type parameter count is 1, but its 'common' declaration requires 0
// ASSERT: scan-1 'common' declaration is here
// ASSERT: scan-not Internal Compiler Error
package cmp

specific func foo<T>(): Unit{}

specific class A0 {
    specific func foo<T>(): Unit{}
}

specific class A1<T> {
    specific func foo(): Unit{}
}

