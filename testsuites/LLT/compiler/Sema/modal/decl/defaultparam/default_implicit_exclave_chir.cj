// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func makeC(): C @local! {
    exclave { C() }
}

func foo(y!: C @local! = makeC()) {}

main() {
    foo()
}
