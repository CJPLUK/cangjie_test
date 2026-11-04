// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %frontendCompiler %local %f

interface I {}

class A <: I {
    init() {}
    init(this @local?) { exclave { } }

    func test(): Unit {
        let a: ?A @local? = Some(A())
        let i: I @local? = A()
        let v0: ??I @local? = Some(i)
    }
}

main() {
}
