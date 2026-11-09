// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

interface I {
    mut prop x: Int64 @local! {
        get() { 1 }
        set(_) {}
    }
}

interface J {
    mut prop x: Int64 @local! {
        get() { 2 }
        set(_) {}
    }
}

class C <: I & J {
    var base: Int64 = 0
    init() {}
    init(this @local!) {
        exclave {
            base = 0
        }
    }
    public mut prop x: Int64 @local! {
        get() { 11 }
        set(v) { base = v }
    }
}

func readx<U>(a: U): Int64 where U <: I & J {
    return a.x
}

main(): Int64 {
    let c = C()
    return readx(c)
}

// ASSERT: scan "DiagKind": "sema_no_match_prop_accessor_for_call",
// ASSERT: scan "Errors": 1,
