// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'Extern' type
// ASSERT: scan use 'as' for ordinary type conversions

// Negative: branch selection depends only on whether `Foo` resolves to a type.
// Therefore `(Foo)(arg)` is a forced cast even though `arg` is not Extern<T>, and it
// must report the forced-cast diagnostic instead of falling back to `Foo(arg)`.
// `Foo` deliberately has a matching constructor so the old fallback behavior would
// make this test compile successfully. The valid constructor spelling is `Foo(arg)`.

class Foo {
    public init(value: Int64) {}
}

main() {
    let arg: Int64 = 1
    let value = (Foo)(arg)
}
