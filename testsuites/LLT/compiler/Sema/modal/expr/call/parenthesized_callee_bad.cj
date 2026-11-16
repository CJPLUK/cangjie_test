// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

func take(s: String @local!) {}
func check(s: String @local!) {
    (take)(s)
    ((take))(s)
    let f: (String @local!) -> Unit = take
    ((f))(s)
}
class C {
    public func read(this @local!): Int64 { 1 }
}
func wrappedReceiver(c: C @local!) { ((c)).read() }
main() {}

// ASSERT: scan-4 "DiagKind": "sema_external_local_arg",
// ASSERT: scan-3 "Message": "cannot pass argument of external @local! to @local! parameter",
// ASSERT: scan-1 "Message": "cannot pass argument of external @local! to @local! this parameter",
// ASSERT: scan "Errors": 4,
