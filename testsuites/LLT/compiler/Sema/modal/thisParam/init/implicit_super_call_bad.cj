// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

open class F {
    init() {}
}
class G <: F {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

main() {
}

// ASSERT: scan-2 "DiagKind": "sema_no_match_function_declaration_for_call",
// ASSERT: scan-2 "DiagKind": "sema_no_non_param_constructor_in_super_class",
// ASSERT: scan "Errors": 4,
