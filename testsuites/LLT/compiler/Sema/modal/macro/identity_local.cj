// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: %n.macro.cj
// EXEC: %compiler %local %cmp_macro %n.macro.cj
// EXEC: %run_macro %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import identity_local_macro.*

@Identity
class _Placeholder {}

main() {
    let b = Box.make()
    let s = b.take("hi")
    let n = b.half()
    let e = echo("ok")
    if (s.size + n + e.size > 0) {
        println("ok")
    }
}
