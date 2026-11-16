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
// Unsupported shared toArray operations must throw.
// A fully local receiver produces a live entry view; the shared receiver stays rejected.

import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0
    let m: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    m.add("a", 1)
    let q: HashMap<String, Int64> @local? = m

    // A shared receiver cannot produce a new array.
    var toArrayThrew = false
    try {
        let _: Array<(String, Int64)> @local? = q.toArray()
    } catch (e: Exception) {
        toArrayThrew = true
    }
    failed += assertB(toArrayThrew, "S19_limits_toarray_q_throws")

    // A fully local receiver creates a live entry view over the map.
    var entryOk = false
    try {
        let ev: MapEntryView<String, Int64> @local! = m.entryView("a")
        let got: ?Int64 @local! = ev.value
        match (got) {
            case Some(v) => if (v == 1) { entryOk = true }
            case None => ()
        }
    } catch (e: Exception) {
        entryOk = false
    }
    failed += assertB(entryOk, "S19_limits_entryview_bang_live")

    // Shared keys and values views cannot produce local arrays.
    let keysQ: EquatableCollection<String> @local? = q.keys()
    var keysToArrayThrew = false
    try {
        let _: Array<String> @local? = keysQ.toArray()
    } catch (e: Exception) {
        keysToArrayThrew = true
    }
    failed += assertB(keysToArrayThrew, "S19_limits_keys_q_toarray_throws")

    let valsQ: Collection<Int64> @local? = q.values()
    var valsToArrayThrew = false
    try {
        let _: Array<Int64> @local? = valsQ.toArray()
    } catch (e: Exception) {
        valsToArrayThrew = true
    }
    failed += assertB(valsToArrayThrew, "S19_limits_values_q_toarray_throws")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
