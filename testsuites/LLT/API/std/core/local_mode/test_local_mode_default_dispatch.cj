/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖设计项（LM-DOC-20260910）：T432。

import std.core.*

class T432DispatchDefault <: ToString {
    public func toString(): String {
        "legacy-default"
    }
}

class T432DispatchOverride <: ToString {
    public func toString(): String {
        "legacy-override"
    }

    public func toString(this @local?): String @local! {
        exclave {
            let text: String @local! = "local-override"
            text
        }
    }
}

main(): Int64 {
    var failed = 0

    let heapDefault = T432DispatchDefault()
    let defaultAsInterface: ToString @local? = heapDefault
    var defaultCaught = false
    try {
        let result: String @local! = defaultAsInterface.toString()
        let _ = result
    } catch (e: UnimplementedException) {
        defaultCaught = true
    }
    failed += assertB(defaultCaught, "T432_default_interface_throws")
    failed += assertEq(heapDefault.toString(), "legacy-default", "T432_default_heap")

    let heapOverride = T432DispatchOverride()
    let overrideAsInterface: ToString @local? = heapOverride
    let localResult: String @local! = overrideAsInterface.toString()
    failed += assertB(localResult == "local-override", "T432_override_interface_value")
    failed += assertEq(heapOverride.toString(), "legacy-override", "T432_override_heap_value")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
