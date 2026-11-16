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
// Cover local collection copying, bulk insertion, and iterator invalidation.

import std.collection.*
import std.core.*

// A non-Copyable element for copy-isolation checks.
class ReviewBox {
    var v: Int64 = 0
    init() {}
    init(v0: Int64) { v = v0 }
    public exclave init(this @local!) {}
    public exclave init(this @local!, v0: Int64) { v = v0 }
}

// Remove elements whose value is 1.
exclave func rfKeepV(b: ReviewBox @local!): Bool {
    b.v == 1
}

// Expand even values into two elements and odd values into an empty list.
exclave func rfExpand(v: Int64 @local!): ArrayList<Int64> @local! {
    let out: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    if (v % 2 == 0) {
        out.add(v)
        out.add(v * 10)
    }
    out
}

main(): Int64 {
    var failed = 0

    // Insert from a collection view at a nonzero offset.
    let hmk: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    hmk.add("a", 1)
    hmk.add("b", 2)
    hmk.add("c", 3)
    let kv: Collection<Int64> @local! = hmk.values()
    let expected: Array<Int64> @local! = kv.toArray()
    let al: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    al.add(10)
    al.add(20)
    al.add(all: kv, at: 1)
    failed += assertEq(al.size, 5, "ADD_ALL_AT_generic_size")
    failed += assertEq(al[0], 10, "ADD_ALL_AT_generic_head")
    failed += assertEq(al[1], expected[0], "ADD_ALL_AT_generic_k1")
    failed += assertEq(al[2], expected[1], "ADD_ALL_AT_generic_k2")
    failed += assertEq(al[3], expected[2], "ADD_ALL_AT_generic_k3")
    failed += assertEq(al[4], 20, "ADD_ALL_AT_generic_tail")

    // Insert from an Array source.
    let arrSrc: Array<Int64> @local! = [7, 8]
    al.add(all: arrSrc, at: 0)
    failed += assertEq(al.size, 7, "ADD_ALL_AT_array_size")
    failed += assertEq(al[0], 7, "ADD_ALL_AT_array_first")
    failed += assertEq(al[2], 10, "ADD_ALL_AT_array_shifted")

    // A shared HashMap constructor must create an independent copy.
    let hm: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    hm.add("a", 1)
    hm.add("b", 2)
    let hmQ: HashMap<String, Int64> @local? = hm
    let hmCopy: HashMap<String, Int64> @local? = HashMap<String, Int64>(hmQ) @local?
    failed += assertEq(hmCopy.size, 2, "HMINIT_q_snapshot_size")
    failed += assertB(hmCopy.contains("a") && hmCopy.contains("b"), "HMINIT_q_snapshot_content")
    hm.add("new", 7)
    failed += assertEq(hmCopy.size, 2, "HMINIT_q_independent_size")
    failed += assertB(!hmCopy.contains("new"), "HMINIT_q_independent_content")
    match (hmCopy.get("a")) {
        case Some(v) =>
            failed += assertEq(v, 1, "HMINIT_q_value_read")
        case None =>
            failed += 1
    }

    // Keys and values iterators must detect structural changes.
    let kq: EquatableCollection<String> @local? = hmQ.keys()
    let kit = kq.iterator()
    let _firstK: Option<String> @local? = kit.next()
    hm.add("mutator", 1)
    var kThrew = false
    try {
        let _nextK: Option<String> @local? = kit.next()
    } catch (e: ConcurrentModificationException) {
        kThrew = true
    }
    failed += assertB(kThrew, "KEYS_ITER_cme")

    let vq: Collection<Int64> @local? = hmQ.values()
    let vit = vq.iterator()
    let _firstV: Option<Int64> @local? = vit.next()
    hm.remove("a")
    var vThrew = false
    try {
        let _nextV: Option<Int64> @local? = vit.next()
    } catch (e: ConcurrentModificationException) {
        vThrew = true
    }
    failed += assertB(vThrew, "VALUES_ITER_cme")

    // flatMap preserves output order and handles empty results.
    let srcAl: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    srcAl.add(1)
    srcAl.add(2)
    srcAl.add(3)
    srcAl.add(4)
    let fm: ArrayList<Int64> @local! = srcAl.flatMap(rfExpand)
    failed += assertEq(fm.size, 4, "FLATMAP_size")
    failed += assertEq(fm[0], 2, "FLATMAP_first")
    failed += assertEq(fm[1], 20, "FLATMAP_second")
    failed += assertEq(fm[2], 4, "FLATMAP_third")
    failed += assertEq(fm[3], 40, "FLATMAP_fourth")
    failed += assertEq(fm.capacity, 4, "FLATMAP_capacity_exact")
    // An empty source produces an empty result.
    let emptySrc: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    let fmEmpty: ArrayList<Int64> @local! = emptySrc.flatMap(rfExpand)
    failed += assertEq(fmEmpty.size, 0, "FLATMAP_empty_size")

    // Lists built from one source array must not share mutable storage.
    let srcArr: Array<ReviewBox> @local! = [ReviewBox(1) @local!, ReviewBox(2) @local!]
    let la: ArrayList<ReviewBox> @local! = ArrayList<ReviewBox>(srcArr) @local!
    let lbx: ArrayList<ReviewBox> @local! = ArrayList<ReviewBox>(srcArr) @local!
    lbx.removeIf(rfKeepV)
    failed += assertEq(lbx.size, 1, "ALIAS_removeif_size")
    failed += assertEq(la.size, 2, "ALIAS_other_size")
    failed += assertEq(la[0].v, 1, "ALIAS_other_elem0")
    failed += assertEq(la[1].v, 2, "ALIAS_other_elem1")
    failed += assertEq(srcArr[0].v, 1, "ALIAS_src_elem0")
    failed += assertEq(srcArr[1].v, 2, "ALIAS_src_elem1")

    // A shared Array source is copied during construction.
    let srcQ: Array<Int64> @local! = [1, 2]
    let srcQv: Array<Int64> @local? = srcQ
    let alq: ArrayList<Int64> @local? = ArrayList<Int64>(srcQv) @local?
    failed += assertEq(alq.size, 2, "INIT_q_copy_size")
    srcQ[0] = 99
    var sumQ = 0
    for (x in alq) {
        if (x == 1) { sumQ += 1 }
        if (x == 2) { sumQ += 2 }
    }
    failed += assertEq(sumQ, 3, "INIT_q_copy_independent")

    // Append elements from a values view.
    let al3: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    al3.add(5)
    let kv2: Collection<Int64> @local! = hmk.values()
    al3.add(all: kv2)
    failed += assertEq(al3.size, 4, "ADDALL_generic_size")
    failed += assertEq(al3[0], 5, "ADDALL_generic_head")
    failed += assertEq(al3[1], expected[0], "ADDALL_generic_k1")

    // Compare shared HashMap receivers for identity and unequal content.
    let hmQEq: HashMap<String, Int64> @local? = hm
    failed += assertB(hmQEq == hmQEq, "EQ_refeq_smoke")
    failed += assertB(!(hmQEq == hmCopy), "EQ_distinct_objects")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
