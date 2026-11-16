// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

func foo() {
    let a: Int @local! = 1
    let b: Int @local? = a
    let c: Int @local! = b
    let d: Int @~local = c
}

main() {}