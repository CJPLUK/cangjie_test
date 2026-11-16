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
// T302: ArrayList(Collection<String> @local!) for Array-backed and
// ArrayList-backed collections.
// UPDATE 2026-09-29: both overloads resolve and the case runs ALL PASSED on the
// 2026-09-28 SDK, so the earlier EXPECTED-COMPILE-FAIL / DISABLED-EXEC record
// (which described the 0907 SDK exporting only Array<T> @local!) is obsolete.

import std.collection.*
import std.core.*

main(): Int64 {
    let sourceArray: Array<String> @local! = ["a", "b"]
    let arrayCollection: Collection<String> @local! = sourceArray
    let fromArray: ArrayList<String> @local! = ArrayList<String>(arrayCollection) @local!
    let sourceList: ArrayList<String> @local! = ArrayList<String>(sourceArray) @local!
    let listCollection: Collection<String> @local! = sourceList
    let fromList: ArrayList<String> @local! = ArrayList<String>(listCollection) @local!
    if (fromArray.size != 2 || fromList.size != 2) {
        return 1
    }
    println("ALL PASSED")
    return 0
}
