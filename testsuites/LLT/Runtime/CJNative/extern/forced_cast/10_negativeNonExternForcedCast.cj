// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'Extern' type
// ASSERT: scan use 'as' for ordinary type conversions

// Negative: the operand of `(U)e` is not Extern<T>, for both a plain class target
// and a generic-type target. The forced-cast candidate must be rejected (no
// fabricated conversion from an ordinary value).

class Foo {}

class Box<T> {}

main() {
    let plainTarget: Foo = (Foo)1
    let genericTarget: Box<Int64> = (Box<Int64>)1
}
