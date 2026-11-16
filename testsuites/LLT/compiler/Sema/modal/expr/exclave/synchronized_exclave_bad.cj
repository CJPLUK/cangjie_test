// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

import std.sync.Mutex
func f(s: String @local!) {
    synchronized (Mutex()) {
        exclave {}
    }
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_invalid_exclave",
// ASSERT: scan "Errors": 1,
