// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit all 2>&1 | compare %f

struct NC { let value: Int64 = 0 }
class C {
    var field: NC
    var callback: () -> Unit
    init(this @local?) {
        exclave {
            field = NC()
            callback = { => field = NC() }
        }
    }
    init(this @local?, x: Int64) {
        exclave {
            field = NC()
            callback = { => this.field = NC() }
        }
    }
    init(this @local?, x: Bool) {
        exclave {
            field = NC()
            @local? func write() { field = NC() }
            callback = write
        }
    }
}
main() {}

// ASSERT: scan-3 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 3,
