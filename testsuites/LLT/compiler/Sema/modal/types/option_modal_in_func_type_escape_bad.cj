// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

var escaped: ?String = None
exclave func make(): ?String @local? { None }

func check() {
    let a: (?String @local?) -> Unit = { x => escaped = x }
    let b: (Option<String> @local?) -> Unit = { x => escaped = x }
    let d: () -> ?String @local? = make
    let e: () -> Option<String> @local? = make
    escaped = d()
    escaped = e()
    let f: ?(?String @local?) -> Unit = { x => escaped = x }
    let g: ?(Option<String> @local?) -> Unit = { x => escaped = x }
}
main() {}

// ASSERT: scan-6 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 6,
