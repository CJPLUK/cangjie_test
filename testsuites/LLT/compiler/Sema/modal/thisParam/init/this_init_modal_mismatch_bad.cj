// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -Woff all 2>&1 | compare %f

// this() must delegate to an init with the same @local modal.

class ToNotLocal {
    init() {}
    init(this @local?) { exclave { } }
    init(this @local!, _: Int) { exclave { this() } }
}

class ToFull {
    init(this @local!) { exclave { } }
    init(this @local?, _: Int) { exclave { this() } }
}

class ToHalf {
    init(this @local?) { exclave { } }
    init(this @local!, _: Int) { exclave { this() } }
}

class ToNotLocalFromHalf {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?, _: Int) { exclave { this() } }
}

struct StructToFull {
    init(this @local!) { exclave { } }
    init(this @local?, _: Int) { exclave { this() } }
}

main() {}

// ASSERT: scan-5 "DiagKind": "sema_no_match_function_declaration_for_call",
// ASSERT: scan "Errors": 5,
