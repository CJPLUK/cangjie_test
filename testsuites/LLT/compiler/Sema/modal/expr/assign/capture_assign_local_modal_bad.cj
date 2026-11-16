// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class NC {
    init() {}
    init(this @local!) { exclave { } }
}

func outer() {
    var x: NC@local! = NC()
    func inner() {
        x = NC()
    }
}

class NCC {
    var x: NC
    init() {
        x = NC()
    }
    exclave init(this @local!) {
        x = NC()
    }

    func bam(this @local?) {
        @local? func jam() {
            x = NC() @local!
            x = NC() @~local
        }
    }
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan-2 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 3,
