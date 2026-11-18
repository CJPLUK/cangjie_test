// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %diag_json %f 2>&1 | compare %f

main(): Unit {
    let value: Int64 = broken()
}

func broken<T>() {
    missingValue
}

// ASSERT: scan-1 "DiagKind": "sema_undeclared_identifier",
// ASSERT: scan-not "DiagKind": "sema_unable_to_infer_generic_func",
