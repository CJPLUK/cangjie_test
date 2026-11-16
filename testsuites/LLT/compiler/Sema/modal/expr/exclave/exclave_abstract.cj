// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -Woff all 2>&1 | compare %f
abstract class C {
    public exclave func foo(): String @local!
}

interface I {
    exclave func bar(): String @local!
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_abstract_exclave_func",
// ASSERT: scan "Errors": 2,
