/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Open method dispatched through a parent reference and through an interface.
// The vtable slot must be the woven wrapper, not the renamed original.

// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler %import-cangjie-stdx %cmp_opt %f -o %output %collect_aspects_plugin
// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler %import-cangjie-stdx %cmp_opt %f -o %output %weave_aspects_plugin
// EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_args | compare %f
// ASSERT: scan #----- aspect -----#\n#----- original -----#\n2\n#----- aspect -----#\n#----- original -----#\n2\n
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.aspect_cj.*

interface I {
    func foo(): Int64
}

open class CA <: I {
    @ReplaceFuncBody[packageName: "default", className: "CA", methodName: "foo", isStatic: false,
        recursive: false]
    public func aspect(original: () -> Int64): Int64 {
        println("#----- aspect -----#")
        original() + 1
    }

    public open func foo(): Int64 {
        println("#----- original -----#")
        1
    }
}

class CB <: CA {}

main() {
    let parent: CA = CB()
    println(parent.foo())
    let iface: I = CB()
    println(iface.foo())
    0
}
