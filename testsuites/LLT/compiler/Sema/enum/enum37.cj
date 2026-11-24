// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %diag_json %f 2>&1 | compare %f

func test1(v: Any) {}

func test2(v: ToString) {}

main() {
    let x = Some(None)
    test1(None)
    test2(None)
    0
}

// ASSERT: scan-3 "DiagKind": "sema_generic_type_without_type_argument",
// ASSERT: scan-not "DiagKind": "sema_unable_to_infer_generic_func",
// ASSERT: scan "Errors": 3,
