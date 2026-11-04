// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %enableEH %diag_json %f -o %output -Woff all 2>&1 | compare %f

import stdx.effect.Command

class F {
    init(this @local!) { exclave { } }
}

class Eff <: Command<F> {}

main() {
    let x: F@local! = F()
    try {
        perform x
    } handle (e: Eff) {
        resume with F()
    }
}

// ASSERT: scan "DiagKind": "sema_expected_data_type",
