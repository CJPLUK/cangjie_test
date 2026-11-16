// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -Woff all 2>&1 | compare %f

class Box {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

func testInternalCannotReceiveHalf() {
    var a: (Int64, Box) @local! = (1, Box()@local!)
    var b: (Int64, Box) @local? = a
    a = b
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 1,
