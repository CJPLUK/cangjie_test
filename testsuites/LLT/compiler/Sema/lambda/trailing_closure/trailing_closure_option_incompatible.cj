// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %frontendCompiler %diag_json %f 2>&1 | compare %f
class C {}
func f(p: Object, h: ?() -> Unit): Unit {}
func f(p: Any, h: () -> Unit): Unit {}
main() {
    f(C()) { println("hello") }
}

// ASSERT: scan-1 "DiagKind": "sema_ambiguous_match",
// ASSERT: scan "Errors": 1,