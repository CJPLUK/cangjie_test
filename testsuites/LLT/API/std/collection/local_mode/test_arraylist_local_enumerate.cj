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
// T334: enumerate-only process with empty and [a,b] inputs.  Expected result is
// an exact ArrayList<(Int64,String)> @local! with (0,"a"),(1,"b").
// UPDATE 2026-09-29: the case runs ALL PASSED on the 2026-09-28 SDK; the earlier
// "field must reference heap object" abort record is obsolete.

import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0
    let emptySource: Array<String> @local! = []
    let empty: ArrayList<String> @local! = ArrayList<String>(emptySource) @local!
    let emptyEnumerated: ArrayList<(Int64, String)> @local! = empty.enumerate()
    failed += assertEq(emptyEnumerated.size, 0, "T334_empty_size")

    let source: Array<String> @local! = ["a", "b"]
    let list: ArrayList<String> @local! = ArrayList<String>(source) @local!
    let enumerated: ArrayList<(Int64, String)> @local! = list.enumerate()
    failed += assertEq(enumerated.size, 2, "T334_many_size")
    let first: (Int64, String) @local! = enumerated[0]
    let second: (Int64, String) @local! = enumerated[1]
    failed += assertEq(first[0], 0, "T334_index0")
    failed += assertEq(second[0], 1, "T334_index1")
    let firstString: String @local! = first[1]
    let secondString: String @local! = second[1]
    failed += assertB(firstString == "a", "T334_value0")
    failed += assertB(secondString == "b", "T334_value1")

    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
