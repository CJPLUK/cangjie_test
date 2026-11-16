/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Struct mut method reached through the interface vtable. A duplicate candidate
// with the same srcCodeName makes mut-wrapper lookup fail, and the original
// body must not run without the aspect.

// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler %import-cangjie-stdx %cmp_opt %f -o %output %collect_aspects_plugin
// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler %import-cangjie-stdx %cmp_opt %f -o %output %weave_aspects_plugin
// EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_args | compare %f
// ASSERT: scan #----- aspect -----#\n#----- original -----#\n2\n
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.aspect_cj.*

interface I {
    mut func foo(): Int64
}

struct S <: I {
    public var n: Int64 = 0

    @ReplaceFuncBody[packageName: "default", className: "S", methodName: "foo", isStatic: false,
        recursive: false]
    public mut func aspect(original: () -> Int64): Int64 {
        println("#----- aspect -----#")
        original() + 1
    }

    public mut func foo(): Int64 {
        println("#----- original -----#")
        n = 1
        n
    }
}

main() {
    var s = S()
    let i: I = s
    println(i.foo())
    0
}
