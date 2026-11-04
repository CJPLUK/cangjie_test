// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

struct P {
    var x: Int64 = 0
    init() {}
    init(this @local!) { exclave { x = 0 } }
}

func varrayReturnExternal(a: P @local!): VArray<P, $2> @local! {
    [a, a]
}

func varrayReturnInternal(): VArray<P, $2> @local! {
    [P() @local!, P() @local!]
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
