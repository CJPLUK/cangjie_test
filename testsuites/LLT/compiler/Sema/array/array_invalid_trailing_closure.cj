// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE)EXEC-PIPE-1: %frontendCompiler %diag_json %f 2>&1 | compare %f

main(): Int64 {
    let arr1 = Array<Int64>() {i => i}

    let arr2 = Array<Int64>(1) {i}

    let arr3 = Array<Int64>(1, 2) {i => i}
    return 0
}

// ASSERT: scan "DiagKind": "sema_undeclared_identifier",
// ASSERT: scan-2 "DiagKind": "sema_wrong_number_of_arguments",
// ASSERT: scan "Errors": 3,
