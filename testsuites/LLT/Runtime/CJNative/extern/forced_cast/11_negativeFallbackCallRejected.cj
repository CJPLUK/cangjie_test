// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'Extern' type
// ASSERT: scan use 'as' for ordinary type conversions

// Negative: `(Foo)(1)` has both a forced-cast candidate and the ordinary
// parenthesized-call shape. `Foo` is a type but `1` is not Extern<T>, so the forced
// cast is rejected; the ordinary reading `Foo(1)` is then attempted as a constructor
// call and, finding no matching constructor, also fails. Because `Foo` is a type the
// construct is reported as a malformed forced cast (a well-formed `(U)(args)`
// constructor call that matches a constructor still succeeds).

class Foo {}

main() {
    let value = (Foo)(1)
}
