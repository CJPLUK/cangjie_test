// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit all 2>&1 | compare %f

struct S <: Copyable {}
struct F <: Copyable {}


main() {
    let s = [S(), F()]
}

// ASSERT: scan-1 "DiagKind": "sema_illegal_copy_type_usage",
// ASSERT: scan "Errors": 1,
