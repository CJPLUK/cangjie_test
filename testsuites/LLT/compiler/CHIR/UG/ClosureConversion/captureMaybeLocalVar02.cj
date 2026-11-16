// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Runtime guard: a modal but `Copyable` capture must keep a heap-allocated box.
// `Int64 @local?` IsModal() but IsCopyable(), so SetMemRegion opens no region for it.
// Stamping the modal on the box class (which is never Copyable) would allocate it
// local with no enclosing region, and the heap AutoEnv referencing it aborts with
// "heap object must not reference local object".
// Lambdas capturing mutable vars must be called directly, so no escaping form exists.

// EXEC: %compiler %f %local -o %n.%suffix
// EXEC: %run %run_opt %n.%suffix | compare %f
// ASSERT: scan 2\n15

main() {
    var n: Int64 @local? = 0
    { => n = n + 1 }()
    { => n = n + 1 }()
    println(n)

    var s: Int64 @local! = 10
    { => s = s + 5 }()
    println(s)
}
