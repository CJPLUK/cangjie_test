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
// Check local Map dispatch, collection membership, and heap overloads.

import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0

    // Dispatch through a fully local Map receiver.
    let hm: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    hm.add("a", 1)
    hm.add("b", 2)
    let mi: Map<String, Int64> @local! = hm

    // Read through the interface.
    match (mi.get("a")) {
        case Some(v) =>
            failed += assertEq(v, 1, "MAP_bang_get_a")
        case None =>
            failed += 1
    }
    failed += assertEq(mi["b"], 2, "MAP_bang_index_b")

    // Replacing an entry returns its previous value.
    match (mi.add("b", 20)) {
        case Some(old) =>
            failed += assertEq(old, 2, "MAP_bang_add_old")
        case None =>
            failed += 1
    }
    failed += assertEq(mi["b"], 20, "MAP_bang_add_overwritten")
    match (mi.add("b", 2)) {
        case Some(old) =>
            failed += assertEq(old, 20, "MAP_bang_add_restore")
        case None =>
            failed += 1
    }

    // addIfAbsent preserves existing values and inserts missing keys.
    match (mi.addIfAbsent("a", 9)) {
        case Some(old) =>
            failed += assertEq(old, 1, "MAP_bang_addifabsent_old")
        case None =>
            failed += 1
    }
    failed += assertEq(mi["a"], 1, "MAP_bang_addifabsent_no_overwrite")
    match (mi.addIfAbsent("new", 9)) {
        case Some(_) =>
            failed += 1
        case None =>
            ()
    }
    failed += assertEq(hm.size, 3, "MAP_bang_addifabsent_inserted")

    // replace updates existing keys and leaves missing keys absent.
    match (mi.replace("a", 9)) {
        case Some(old) =>
            failed += assertEq(old, 1, "MAP_bang_replace_old")
        case None =>
            failed += 1
    }
    failed += assertEq(mi["a"], 9, "MAP_bang_replace_applied")
    match (mi.replace("absent", 9)) {
        case Some(_) =>
            failed += 1
        case None =>
            ()
    }
    failed += assertEq(hm.size, 3, "MAP_bang_replace_absent_noop")

    // Set and remove entries through the interface.
    mi["c"] = 7
    failed += assertEq(mi["c"], 7, "MAP_bang_index_set")
    match (mi.remove("a")) {
        case Some(v) =>
            failed += assertEq(v, 9, "MAP_bang_remove_value")
        case None =>
            failed += 1
    }
    failed += assertEq(hm.size, 3, "MAP_bang_remove_size")

    // Clearing another map must not affect this map.
    let hm2: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    hm2.add("x", 1)
    hm2.add("y", 2)
    let mi2: Map<String, Int64> @local! = hm2
    mi2.clear()
    failed += assertEq(hm2.size, 0, "MAP_bang_clear_size")
    match (mi2.get("x")) {
        case Some(_) =>
            failed += 1
        case None =>
            ()
    }
    failed += assertEq(hm.size, 3, "MAP_bang_clear_other_intact")

    // Dispatch through a shared Map receiver.
    let hq: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    hq.add("a", 1)
    hq.add("b", 2)
    let mq: Map<String, Int64> @local? = hq

    match (mq.get("a")) {
        case Some(v) =>
            failed += assertEq(v, 1, "MAP_q_get_a")
        case None =>
            failed += 1
    }
    failed += assertEq(mq["b"], 2, "MAP_q_index_b")
    failed += assertB(mq.contains("a"), "MAP_q_contains_hit")
    failed += assertB(!mq.contains("zz"), "MAP_q_contains_miss")
    let probe: ArrayList<String> @local! = ArrayList<String>() @local!
    probe.add("a")
    failed += assertB(mq.contains(all: probe), "MAP_q_contains_all_hit")
    probe.add("zz")
    failed += assertB(!mq.contains(all: probe), "MAP_q_contains_all_miss")

    // Check membership through a shared EquatableCollection.
    let kq: EquatableCollection<String> @local? = mq.keys()
    failed += assertB(kq.contains("a"), "EQC_q_contains_hit")
    failed += assertB(!kq.contains("zz"), "EQC_q_contains_miss")
    let probe2: ArrayList<String> @local! = ArrayList<String>() @local!
    probe2.add("a")
    failed += assertB(kq.contains(all: probe2), "EQC_q_contains_all_hit")
    probe2.add("zz")
    failed += assertB(!kq.contains(all: probe2), "EQC_q_contains_all_miss")

    // Heap overloads retain their behavior.
    let plain: HashMap<String, Int64> = HashMap<String, Int64>()
    plain.add("a", 1)
    plain.add("b", 2)
    match (plain.get("a")) {
        case Some(v) =>
            failed += assertEq(v, 1, "MAP_plain_get_a")
        case None =>
            failed += 1
    }
    failed += assertB(plain.contains("b"), "MAP_plain_contains")
    match (plain.addIfAbsent("a", 99)) {
        case Some(old) =>
            failed += assertEq(old, 1, "MAP_plain_addifabsent_old")
        case None =>
            failed += 1
    }
    failed += assertEq(plain["a"], 1, "MAP_plain_addifabsent_no_overwrite")
    match (plain.replace("b", 22)) {
        case Some(old) =>
            failed += assertEq(old, 2, "MAP_plain_replace_old")
        case None =>
            failed += 1
    }
    failed += assertEq(plain["b"], 22, "MAP_plain_replace_applied")
    let pk: EquatableCollection<String> = plain.keys()
    failed += assertB(pk.contains("a"), "MAP_plain_keys_contains")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
