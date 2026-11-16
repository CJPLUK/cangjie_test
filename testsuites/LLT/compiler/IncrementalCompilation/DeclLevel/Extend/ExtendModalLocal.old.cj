class C {
    init() {}
    init(this @local!) { exclave { } }
}

extend C {
    func localFoo(this @local!): Int64 {
        1
    }
    func notLocalBar(): Int64 {
        2
    }
}

func useLocal(): Int64 {
    let c: C @local! = C()
    c.localFoo()
}

main(): Int64 {
    useLocal()
}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
