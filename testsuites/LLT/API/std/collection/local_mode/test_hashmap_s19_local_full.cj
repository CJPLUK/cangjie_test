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
// Cover local HashMap constructors, mutations, views, conversions, and higher-order operations.
// Unsupported local operations are checked in test_hashmap_s19_local_limits.cj.

import std.collection.*
import std.core.*

// Return a local pair from the constructor callback.
exclave func s19KV(i: Int64): (String, Int64) @local! {
    let prefix: String @local! = "s"
    let k: String @local! = prefix + i.toString()
    (k, i * 10)
}

class S19Counter {
    var n: Int64 = 0
    func bump(): Unit { n++ }
}

main(): Int64 {
    var failed = 0
    let k1: String @local! = "a"
    let k2: String @local! = "b"
    let k3: String @local! = "c"

    // Construct empty, populated, and capacity-reserved maps.
    let empty: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    failed += assertEq(empty.size, 0, "S19_ctor_empty_size")

    let arrSrc: Array<(String, Int64)> @local! = [("k1", 1), ("k2", 2)]
    let fromArr: HashMap<String, Int64> @local! = HashMap<String, Int64>(arrSrc) @local!
    failed += assertEq(fromArr.size, 2, "S19_ctor_array_size")
    failed += assertB(fromArr.contains("k1"), "S19_ctor_array_contains")

    let collSrc: ArrayList<(String, Int64)> @local! = ArrayList<(String, Int64)>() @local!
    collSrc.add(("c1", 100))
    collSrc.add(("c2", 200))
    let fromColl: HashMap<String, Int64> @local! = HashMap<String, Int64>(collSrc) @local!
    failed += assertEq(fromColl.size, 2, "S19_ctor_collection_size")

    let sized: HashMap<String, Int64> @local! = HashMap<String, Int64>(3, s19KV) @local!
    failed += assertEq(sized.size, 3, "S19_ctor_size_initelement")

    let capped: HashMap<String, Int64> @local! = HashMap<String, Int64>(64) @local!
    failed += assertB(capped.capacity >= 64, "S19_ctor_capacity")

    // Mutate entries individually and in bulk.
    let m: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    let v1: Int64 @local! = 1
    let v2: Int64 @local! = 2
    match (m.add(k1, v1)) {
        case Some(_) => failed += 1
        case None => ()
    }
    match (m.add(k1, v2)) {
        case Some(old) => failed += assertEq(old, 1, "S19_add_returns_old")
        case None => failed += 1
    }
    failed += assertEq(m.size, 1, "S19_add_overwrite_size")

    let batch: ArrayList<(String, Int64)> @local! = ArrayList<(String, Int64)>() @local!
    batch.add(("m1", 1))
    batch.add(("m2", 2))
    let dst: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    dst.add(all: batch)
    failed += assertEq(dst.size, 2, "S19_add_all_size")

    let r: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    r.add("a", 1)
    r.add("b", 2)
    r.add("c", 3)
    match (r.remove("b")) {
        case Some(v) => failed += assertEq(v, 2, "S19_remove_value")
        case None => failed += 1
    }
    match (r.remove("nope")) {
        case Some(_) => failed += 1
        case None => ()
    }
    failed += assertEq(r.size, 2, "S19_remove_size")
    failed += assertB(!r.contains("b"), "S19_remove_absent")

    let rk: ArrayList<String> @local! = ArrayList<String>() @local!
    rk.add("a")
    r.remove(all: rk)
    failed += assertB(!r.contains("a") && r.size == 1, "S19_remove_all")

    let ri: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    ri.add("p", 1)
    ri.add("q", 5)
    ri.add("s", 9)
    ri.removeIf({k: String @local?, v: Int64 @local? => v >= 5})
    failed += assertEq(ri.size, 1, "S19_removeif_size")
    failed += assertB(ri.contains("p"), "S19_removeif_keeps")

    let cl: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    cl.add("z", 9)
    cl.add("y", 8)
    cl.add("x", 7)
    cl.clear()
    failed += assertB(cl.isEmpty() && cl.size == 0, "S19_clear")

    let rv: HashMap<String, Int64> @local! = HashMap<String, Int64>(8) @local!
    let capBefore = rv.capacity
    rv.reserve(200)
    failed += assertB(rv.capacity >= 200 && rv.capacity > capBefore, "S19_reserve")

    // Read entries and check key collections.
    let qSrc: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    qSrc.add("a", 1)
    qSrc.add("b", 2)
    qSrc.add("c", 3)
    let q: HashMap<String, Int64> @local? = qSrc
    failed += assertEq(q.size, 3, "S19_q_size")
    failed += assertB(!q.isEmpty(), "S19_q_isempty")
    match (q.get(k1)) {
        case Some(v) => failed += assertEq(v, 1, "S19_q_get")
        case None => failed += 1
    }
    failed += assertEq(q[k2], 2, "S19_q_index")

    let probe: ArrayList<String> @local! = ArrayList<String>() @local!
    probe.add("a")
    probe.add("b")
    failed += assertB(q.contains(all: probe), "S19_q_contains_all_true")
    probe.add("nope")
    failed += assertB(!q.contains(all: probe), "S19_q_contains_all_false")

    // Iterate local keys and values views.
    let km: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    km.add("a", 1)
    km.add("b", 2)
    km.add("c", 3)
    let keys: EquatableCollection<String> @local! = km.keys()
    var kcount = 0
    for (k in keys) { kcount++ }
    failed += assertEq(kcount, 3, "S19_keys_iter")
    failed += assertEq(keys.toArray().size, 3, "S19_keys_toarray")

    let vals: Collection<Int64> @local! = km.values()
    var vsum = 0
    var vcount = 0
    for (v in vals) { vsum += v; vcount++ }
    failed += assertEq(vcount, 3, "S19_values_iter_count")
    failed += assertEq(vsum, 6, "S19_values_iter_sum")
    failed += assertEq(vals.toArray().size, 3, "S19_values_toarray")

    let kmQ: HashMap<String, Int64> @local? = km
    let keysQ: EquatableCollection<String> @local? = kmQ.keys()
    var kqcount = 0
    for (k in keysQ) { kqcount++ }
    failed += assertEq(kqcount, 3, "S19_keys_q_iter")
    let valsQ: Collection<Int64> @local? = kmQ.values()
    var vqsum = 0
    var vqcount = 0
    for (v in valsQ) { vqsum += v; vqcount++ }
    failed += assertEq(vqcount, 3, "S19_values_q_iter_count")
    failed += assertEq(vqsum, 6, "S19_values_q_iter_sum")

    // Convert, clone, render, and compare local maps.
    let pairs: Array<(String, Int64)> @local! = km.toArray()
    failed += assertEq(pairs.size, 3, "S19_toarray_size")
    var psum = 0
    for (i in 0..pairs.size) { psum += pairs[i][1] }
    failed += assertEq(psum, 6, "S19_toarray_content")

    let orig: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    orig.add("a", 1)
    orig.add("b", 2)
    orig.add("c", 3)
    let cloned: HashMap<String, Int64> @local! = orig.clone()
    cloned.add("d", 4)
    cloned.remove("a")
    failed += assertB(orig.size == 3 && orig.contains("a"), "S19_clone_source_intact")
    failed += assertB(cloned.size == 3 && !cloned.contains("a") && cloned.contains("d"), "S19_clone_independent")

    let str: String @local! = kmQ.toString()
    failed += assertB(str.contains("a") && str.contains("b"), "S19_tostring_content")

    // Use identical insertion order to compare local and heap rendering.
    let kmPlain: HashMap<String, Int64> = HashMap<String, Int64>()
    kmPlain.add("a", 1)
    kmPlain.add("b", 2)
    kmPlain.add("c", 3)
    let plainOut: String = kmPlain.toString()
    failed += assertB(str == plainOut, "S19_tostring_equal_plain")

    // Check exact rendering of empty and single-entry maps.
    let emptyBang: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    let emptyQ: HashMap<String, Int64> @local? = emptyBang
    let emptyStr: String @local! = emptyQ.toString()
    failed += assertB(emptyStr == "[]", "S19_tostring_empty")

    let oneBang: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    oneBang.add("a", 1)
    let oneQ: HashMap<String, Int64> @local? = oneBang
    let oneStr: String @local! = oneQ.toString()
    failed += assertB(oneStr == "[(a, 1)]", "S19_tostring_single")

    let e1: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    e1.add("k", 1)
    e1.add("j", 2)
    e1.add("i", 3)
    let e2: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    e2.add("k", 1)
    e2.add("j", 2)
    e2.add("i", 3)
    let e1Q: HashMap<String, Int64> @local? = e1
    let e2Q: HashMap<String, Int64> @local? = e2
    failed += assertB(e1Q == e2Q, "S19_eq_equal")
    e2.add("k", 99)
    failed += assertB(!(e1Q == e2Q), "S19_eq_unequal")

    // Check higher-order operations.
    let hQ: HashMap<String, Int64> @local? = km
    failed += assertB(hQ.all({k: String @local?, v: Int64 @local? => v > 0}), "S19_all_true")
    failed += assertB(!hQ.all({k: String @local?, v: Int64 @local? => v > 1}), "S19_all_false")
    failed += assertB(hQ.any({k: String @local?, v: Int64 @local? => v == 2}), "S19_any_true")
    failed += assertB(!hQ.any({k: String @local?, v: Int64 @local? => v > 99}), "S19_any_false")
    failed += assertB(hQ.none({k: String @local?, v: Int64 @local? => v > 99}), "S19_none_true")
    failed += assertB(!hQ.none({k: String @local?, v: Int64 @local? => v == 1}), "S19_none_false")

    let counter = S19Counter()
    hQ.forEach({k: String @local?, v: Int64 @local? => counter.bump()})
    failed += assertEq(counter.n, 3, "S19_foreach_count")

    let hBang: HashMap<String, Int64> @local! = km
    let mapped: HashMap<String, Int64> @local! = hBang.mapValues({k: String @local?, v: Int64 @local? => v * 10})
    failed += assertEq(mapped.size, 3, "S19_mapvalues_kv_size")
    match (mapped.get("b")) {
        case Some(v) => failed += assertEq(v, 20, "S19_mapvalues_kv_value")
        case None => failed += 1
    }

    let mapped2: HashMap<String, Int64> @local! = hBang.mapValues({v: Int64 @local? => v + 1})
    match (mapped2.get("a")) {
        case Some(v) => failed += assertEq(v, 2, "S19_mapvalues_v_value")
        case None => failed += 1
    }

    let filt: HashMap<String, Int64> @local! = hBang.filter({k: String @local?, v: Int64 @local? => v >= 2})
    failed += assertB(filt.size == 2 && !filt.contains("a"), "S19_filter")

    let folded: Int64 @local! = hBang.fold(0, {acc: Int64 @local!, k: String @local?, v: Int64 @local? => acc + v})
    failed += assertEq(folded, 6, "S19_fold")

    let reduced: Option<Int64> @local! = hBang.reduce({a: Int64 @local!, b: Int64 @local? => a + b})
    match (reduced) {
        case Some(v) => failed += assertEq(v, 6, "S19_reduce")
        case None => failed += 1
    }

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
