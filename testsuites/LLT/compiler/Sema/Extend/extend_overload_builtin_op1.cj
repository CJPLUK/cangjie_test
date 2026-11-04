// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE) EXEC-PIPE-1: %compiler %cmp_opt %f 2>&1 | compare %f

extend Int64 {
    public operator func +(right: Int64) {
        return this
    }
    public operator func ==(right: Int64) {
        return this
    }
    public operator func <<(right: Int64) {
        return this
    }
    public operator func -(right: Int64) {
        return this
    }
    public operator func -() {
        return this
    }
    public operator func [](right: Int64) { // OK
        return this
    }
    public operator func +(right: Int32) { // OK
        return this + Int64(right)
    }
}

extend Bool {
    public operator func ==(right: Bool) {
        return true
    }
    public operator func +(right: Bool) { // OK
        return true
    }
}

// Match the diagnostic contract independently of standard-library source positions.
// ASSERT: regex error: operator func \+\(Int64\) of type Int64 is a built-in function and cannot be overridden
// ASSERT: regex error: operator func ==\(Int64\) of type Int64 is a built-in function and cannot be overridden
// ASSERT: regex error: operator func <<\(Int64\) of type Int64 is a built-in function and cannot be overridden
// ASSERT: regex error: operator func -\(Int64\) of type Int64 is a built-in function and cannot be overridden
// ASSERT: regex error: operator func -\(\) of type Int64 is a built-in function and cannot be overridden
// ASSERT: regex error: operator func ==\(Bool\) of type Bool is a built-in function and cannot be overridden
// ASSERT: regex error: return type of '==' is not identical or not a subtype of the overridden/redefined/implement function
// ASSERT: regex note: 'Int64' is not a subtype of 'Bool'
// ASSERT: regex error: extend member '==' is not allowed to shadow members of 'extend Bool'
// ASSERT: regex error: 'main' is missing
// ASSERT: regex 9 errors generated, 9 errors printed\.
