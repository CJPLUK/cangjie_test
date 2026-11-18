/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-018: the lambda-parameter scanner used to split lambda parameter
// lists at every comma, including the comma inside a generic argument
// `HashMap<String, Int64>`, producing spurious shadowing diagnostics against
// the contract `variable` (audit report 2 #28). A lambda whose parameter type
// contains a generic comma must compile and the aux slot must be readable.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*
import std.collection.*

@Contract [variable v: Int64 = 0]
func varLambdaGeneric(): Int64 {
    let f = { m: HashMap<String, Int64> => m.size }
    return f(HashMap<String, Int64>()) + v
}

main() {
    if (varLambdaGeneric() != 0) {
        throw Exception("lambda with generic parameter type misbehaved")
    }
    println("ok")
}
