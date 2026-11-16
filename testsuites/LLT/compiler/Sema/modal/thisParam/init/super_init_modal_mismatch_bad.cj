// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -Woff all 2>&1 | compare %f

// super() must call a base init with the same @local modal.

open class BaseFull {
    init(this @local!) { exclave { } }
}

class ChildHalf <: BaseFull {
    init(this @local?) { exclave { super() } }
}

open class BaseHalf {
    init(this @local?) { exclave { } }
}

class ChildFull <: BaseHalf {
    init(this @local!) { exclave { super() } }
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_no_match_function_declaration_for_call",
// ASSERT: scan "Errors": 2,
