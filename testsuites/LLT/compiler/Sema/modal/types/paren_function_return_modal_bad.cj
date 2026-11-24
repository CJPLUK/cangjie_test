// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all 2>&1 | compare %f
// ASSERT: scan mismatched types
// ASSERT: scan expected '() -> Class-C @local!', found '() -> Class-C'

class C {
    public init() { }
}
func mkL(): C { return C() }
main(): Int64 {
    let a: () -> (C) @local! = mkL
    0
}

