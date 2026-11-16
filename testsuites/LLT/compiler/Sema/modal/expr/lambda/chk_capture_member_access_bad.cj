// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

open class Base {
    var a = 1
    init(this @local?) { exclave { } }
}

class C <: Base {
    var m = 2
    init(this @local?) { exclave { } }

    prop p: Int64 @local? {
        get() { m }
    }

    func greet(this @local?): Unit {
        println(m)
    }

    func bar(this @local?) {
        let h1:(()->Unit) = { => println(this.a) }
        let h2:(()->Unit) = { => println(super.a) }
        let h3:(()->Unit) = { => println(a) }
        let h4:(()->Unit) = { => println(m) }
        let h5:(()->Unit) = { => this.greet() }
        let h6:(()->Unit) = { => greet() }
        let h7:(()->Unit) = { => println(this.p) }
        let h8:(()->Unit) = { => println(p) }
    }
}

main() {}

// ASSERT: scan-8 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 8,
