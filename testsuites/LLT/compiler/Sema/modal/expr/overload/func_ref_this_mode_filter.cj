// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

class C {
    func foo(this @local!) {}
    func foo(this @local?) {}

    func bar(this @local?) {
        let f = foo
    }
}

func use(c: C @local?) {
    let g = c.foo
}

main() {}
