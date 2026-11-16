// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

// super.foo() with compatible @local modals (child @local? may call base @local? method).

open class Base {
    init() {}
    init(this @local?) { exclave { } }
    func tag(this @local?): Int64 {
        1
    }
}

class Child <: Base {
    init() {}
    init(this @local?) {
        exclave {
            let _ = super.tag()
        }
    }
}

main(): Int64 {
    0
}
