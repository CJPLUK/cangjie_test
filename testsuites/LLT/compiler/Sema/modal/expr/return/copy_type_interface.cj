// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1
struct F <: ToString & Copyable {
    init() {}
    public func toString() {
        "F"
    }
    public exclave func toString(this @local?): String @local! {
        "F"
    }
}
func foo(): ToString @local! {
    F()
}

main() {}
// ASSERT: scan-1 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 1,