// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json 2>&1 | compare %f

class C {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

var ga: C @~local = C()

func foo() {
    var a: C @local! = C()
    var b: C @local? = a
    var c: C @~local = b
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
