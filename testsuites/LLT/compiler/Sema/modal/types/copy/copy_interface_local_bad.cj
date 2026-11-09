// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json 2>&1 | compare %f

class BadCopy <: Copyable {
    init() {}
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_interface_is_not_implementable",
// ASSERT: scan "Errors": 1,
