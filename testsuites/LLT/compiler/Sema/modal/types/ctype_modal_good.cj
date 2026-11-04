// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

@C struct CS {
    var x: Int32
    init() { x = 0 }
}

func foo() {
    let a: CS @local! = CS()
    let b: CS @local? = a
    let c: CS @local! = b
    let d: CS @~local = c
}

main() {}
