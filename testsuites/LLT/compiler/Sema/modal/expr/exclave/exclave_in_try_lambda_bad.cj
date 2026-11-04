// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %diag_json %f 2>&1

func foo() {
    let bad: (Int64) -> Unit = { x => exclave { () } }
}

main() {}
// ASSERT: scan-1 "DiagKind": "sema_exclave_invalid_func_signature",
// ASSERT: scan "Errors": 1,