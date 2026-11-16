// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %diag_json %f -o %output -Woff all 2>&1

func retCopy() {
    true
}
func paramCopy(a: Bool @local!) {}

main() {
    let r: () -> Bool @local! = retCopy
    let p: (Bool) -> Unit = paramCopy
}
// ASSERT: scan-1 "DiagKind": "sema_no_match_function_declaration_for_ref",
// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 2,