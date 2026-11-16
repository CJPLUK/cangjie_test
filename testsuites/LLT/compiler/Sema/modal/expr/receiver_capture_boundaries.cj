// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json 2>&1 | compare %f
// ASSERT: scan-3 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 3,

// Both implicit and explicit method references must reject capturing a non-copyable
// local! receiver. A nested default value cannot capture its instance field either.
class C {
    var x: Int64
    init() { x = 0 }
    exclave init(this @local!) { x = 1 }

    func read(this @local!): Int64 { x }

    func implicitCapture(this @local!) {
        let f = read
    }

    func defaultCapture(this @local!) {
        func nested(v!: Int64 = x): Int64 { v }
        nested()
    }
}

func explicitCapture(value: C@local!) {
    let f = value.read
}

main() {}
