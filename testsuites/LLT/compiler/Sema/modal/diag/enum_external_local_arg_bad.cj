// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

func wrap(s: String @local!) {
    let value: ?String @local! = Some(s)
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_external_local_arg",
// ASSERT: scan-1 "Message": "cannot pass argument of external @local! to @local! parameter",
// ASSERT: scan "Errors": 1,
