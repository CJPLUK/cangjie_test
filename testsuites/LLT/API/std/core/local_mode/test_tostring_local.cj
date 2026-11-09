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

class T432DefaultText <: ToString {
    public func toString(): String {
        "heap-default"
    }
}

class T432ExplicitText <: ToString {
    public func toString(): String {
        "heap-override"
    }

    public func toString(this @local?): String @local! {
        exclave {
            let text: String @local! = "local-override"
            text
        }
    }
}

func t432DefaultLocal(receiver: ToString @local?): Bool {
    var caught = false
    try {
        let result: String @local! = receiver.toString()
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t432ExplicitLocal(receiver: ToString @local?): String @local! {
    exclave {
        receiver.toString()
    }
}

main(): Int64 {
    var failed = 0

    let heapDefault = T432DefaultText()
    failed += assertEq(heapDefault.toString(), "heap-default", "T432_heap_default")

    let defaultLocal: ToString @local? = heapDefault
    failed += assertB(t432DefaultLocal(defaultLocal), "T432_default_local_throws")

    let heapExplicit = T432ExplicitText()
    failed += assertEq(heapExplicit.toString(), "heap-override", "T432_heap_override")

    let explicitLocal: ToString @local? = heapExplicit
    let localResult: String @local! = t432ExplicitLocal(explicitLocal)
    failed += assertB(localResult == "local-override", "T432_explicit_local_value")

    let stringLocal: String @local! = "string-local"
    let stringToString: ToString @local? = stringLocal
    let stringResult: String @local! = stringToString.toString()
    failed += assertB(stringResult == "string-local", "T432_string_local_value")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
