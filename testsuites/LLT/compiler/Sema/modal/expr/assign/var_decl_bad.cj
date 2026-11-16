// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f
func foo(a: String @local!, b: String @local!) {
    let c = a
    let d: String @local! = a
}
main() {}
// ASSERT: scan-2 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan "Errors": 2,