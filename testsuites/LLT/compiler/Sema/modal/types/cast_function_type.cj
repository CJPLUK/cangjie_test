// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

open class F {
    init() {}
    init(this @local!) { exclave { } }
}
class G <: F {
    init() {}
    init(this @local!) { exclave { } }
}
func foo(a: F@local!) : G@local! {
    exclave {
        G()
    }
}

main() {
    let bar: (G@local!) -> F@local? = foo
    bar(G() @local!)
    0
}