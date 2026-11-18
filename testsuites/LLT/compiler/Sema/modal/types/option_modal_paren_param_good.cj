// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

func check() {
    let callback: ((?String) @local?) -> Unit = { _ => }
    let value: ?String @local! = Some("x")
    let twice: (((?String)) @local?) -> Unit = callback
    let thrice: ((((?String))) @local?) -> Unit = callback
    callback(value)
    twice(value)
    thrice(value)
}
main() {}
