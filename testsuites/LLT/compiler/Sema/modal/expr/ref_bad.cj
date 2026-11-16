// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {}
struct A<T> {}

func foo() {
    let b = A<Int @local!> @local! ()
    let c = A<Int @local?> @local? ()
    let d = A<Int @~local> @~local ()
}
main() {}

// ASSERT: scan-3 "DiagKind": "parse_unexpected_modal_type",
