// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json 2>&1 | compare %f
func foo(a: (String,String) @local!){
    bar(a[0])
}
exclave func bar(p: String @local!) {
    println(p)
}
main() {}
// ASSERT: scan-1 "DiagKind": "sema_external_local_arg",
// ASSERT: scan "Errors": 1,