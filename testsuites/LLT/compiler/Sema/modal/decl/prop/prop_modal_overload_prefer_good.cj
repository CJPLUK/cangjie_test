// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

class C {
    init() {}
    init(this @local!) { exclave {} }
    init(this @local?) { exclave {} }
    prop p: Int64 @local! {
        get() { 1 }
    }
    prop p: Int64 @local? {
        get() { 0 }
    }
}

func f() {
    var c: C@local! = C()
    let x = c.p
}

main() {
    f()
}
