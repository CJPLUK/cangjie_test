// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

func foo() {
    let r1: Rune @local! = r'a'
    let r2: Rune @local? = r1
    let r3: Rune @local! = r2
    let r4: Rune @~local = r3

    let f1: Float16 @local! = 1.0f16
    let f2: Float16 @local? = f1
    let f3: Float16 @local! = f2
    let f4: Float16 @~local = f3
}

main() {}
