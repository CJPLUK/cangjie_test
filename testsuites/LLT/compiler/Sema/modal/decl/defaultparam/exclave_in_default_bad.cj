// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func foo(y!: Array<Int64> @local? = exclave { [] }) {
    y
}

main() {
    0
}

// ASSERT: scan "DiagKind": "sema_exclave_outside_function",
// ASSERT: scan "Errors": 1,
