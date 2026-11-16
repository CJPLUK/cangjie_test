// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

exclave func make(): ?String @local? { None }

func check() {
    let a: (?String @local?) -> Unit = { _ => }
    let b: (Option<String> @local?) -> Unit = a
    let d: () -> ?String @local? = make
    let e: () -> Option<String> @local? = d
    let f: ?(?String @local?) -> Unit = a
    let g: ?(Option<String> @local?) -> Unit = f
    let value: ?String @local! = Some("x")
    a(value)
    b(value)
    if (let Some(callback) <- g) { callback(value) }
    let x: ?String @local? = d()
    let y: Option<String> @local? = e()
}
main() {}
