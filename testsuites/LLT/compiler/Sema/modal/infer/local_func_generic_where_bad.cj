// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

interface I {
    func tag(this @local?): Int64
}

class D <: I {
    init() {}
    init(this @local?) { exclave {} }
    public func tag(this @local?): Int64 { 1 }
}

func outer(): Int64 {
    func use2<T>(x: T @local?): Int64 where T <: I {
        exclave { x.tag() }
    }
    let d: D @local? = D()
    use2(d)
    0
}

main() {
    outer()
    0
}

// ASSERT: scan-1 "DiagKind": "sema_exclave_invalid_func_signature",
// ASSERT: scan "Errors": 1,
