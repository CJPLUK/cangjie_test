// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all

class C {
    func foo(this @local?) {}
    func bar(this @local!) {}
    func baz(this @~local) {}
    init(this @local?) { exclave {} }
}

struct S {
    func foo(this @local?) {}
    func bar(this @local!) {}
    func baz(this @~local) {}
    init(this @local?) { exclave {} }
}

enum E {
    | A
    func foo(this @local?) {}
    func bar(this @local!) {}
    func baz(this @~local) {}
}

extend C {
    func jar(this @local?) {}
}

main() {}
