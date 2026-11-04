// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %frontendCompiler %local %f
class C {
    init() {}
    exclave init(this @local!) {}
}

func foo(c: C@local!) {

}

func bar() {
    let _ = { x => exclave {foo(x)} } // { x: C@local! => ... }
    { x => exclave {foo(x)} } // same as above
}

main() {
    bar()
    0
}