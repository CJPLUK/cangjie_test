// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %diag_json 2>&1 | compare %f

main() {
    exclave {
        1
    }
}

// ASSERT: scan "DiagKind": "sema_undeclared_identifier",
