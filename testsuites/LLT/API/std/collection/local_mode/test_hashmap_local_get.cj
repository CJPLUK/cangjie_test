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
// gap audit 2026-09-24 #19（§9.1c）：HashMap.get(this @local?, key: K @local?)。

import std.collection.*
import std.core.*

func gaGetValueIs(m: HashMap<String, Int64> @local?, key: String @local?, expected: Int64): Bool {
    match (m.get(key)) {
        case Some(v) => v == expected
        case None => false
    }
}

func gaGetIsNone(m: HashMap<String, Int64> @local?, key: String @local?): Bool {
    match (m.get(key)) {
        case Some(_) => false
        case None => true
    }
}

main(): Int64 {
    var failed = 0
    let k1: String @local! = "a"
    let k2: String @local! = "b"
    let k3: String @local! = "c"
    let srcInts: Array<Int64> @local! = [1, 2]
    let v1: Int64 @local! = srcInts[0]
    let v2: Int64 @local! = srcInts[1]
    let m: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    m.add(k1, v1)
    m.add(k2, v2)
    let q: HashMap<String, Int64> @local? = m
    failed += assertB(gaGetValueIs(q, k1, 1), "GA19_get_local_q_hit_a")
    failed += assertB(gaGetValueIs(q, k2, 2), "GA19_get_local_q_hit_b")
    failed += assertB(gaGetIsNone(q, k3), "GA19_get_local_q_miss")
    let empty: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    let emptyQ: HashMap<String, Int64> @local? = empty
    failed += assertB(gaGetIsNone(emptyQ, k1), "GA19_get_local_q_empty")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
