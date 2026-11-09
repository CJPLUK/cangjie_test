// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE)EXEC-PIPE-1: %frontendCompiler %diag_json %f 2>&1 | compare %f

main(): Int64 {
    let arr0 = Array(3, ite: 3)
    let arr1: Array<Rune> = Array(3, repeat: 3)
    let arr2: Array<Rune> = Array<Int64>(3, repeat: 3)
    return 0
}

// ASSERT: scan-1 "DiagKind": "sema_unable_to_infer_generic_func",
// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
// ASSERT: scan-1 "DiagKind": "sema_unknown_named_argument",
// ASSERT: scan "Errors": 3,
