// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

func ints(xs: Array<Int64> @local!) {
    xs[0]
    let x = xs[0]
}
func strings(xs: Array<String> @local!) {
    xs[0]
    let x = xs[0]
}
main() {}

// ASSERT: scan-4 "DiagKind": "sema_external_local_arg",
// ASSERT: scan "Errors": 4,
