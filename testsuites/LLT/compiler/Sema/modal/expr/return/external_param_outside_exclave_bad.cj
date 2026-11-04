// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class NC {
    init() {}
    init(this @local!) { exclave { } }
}

func id(a: NC@local!): NC@local! {
    exclave { a }
}

func use(p: NC@local!) {
    id(p)
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_external_local_arg",
// ASSERT: scan-1 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
