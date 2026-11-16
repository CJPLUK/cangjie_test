// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    var mem: Array<Int64> = [1, 2, 3]
    init(this @local!) {
        exclave {}
    }
    func foo(this @local!, y!: Int64 = mem.size) {
        y
    }
}

main(): Int64 {
    0
}

// ASSERT: scan "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 1,
