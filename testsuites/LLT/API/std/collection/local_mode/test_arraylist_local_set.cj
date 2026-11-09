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
// Check owned writes, removals, and rejected indices.

import std.collection.*
import std.core.*

func t309Grow(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.add(1)
        a.add(2)
        if (a.size != 2 || a.capacity != 2) { return 1 }
        0
    }
}

func t310Bulk(a: ArrayList<Int64> @local!, source: Array<Int64> @local!): Int64 {
    exclave {
        a.add(all: source)
        if (a.size != 3 || a[1] != 2 || a[2] != 3) { return 1 }
        0
    }
}

func t310BulkList(a: ArrayList<Int64> @local!, source: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.add(all: source)
        if (a.size != 3 || a[1] != 2 || a[2] != 3) { return 1 }
        0
    }
}

func t311Insert(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.add(9, at: 0)
        a.add(8, at: a.size)
        if (a.size != 4 || a[0] != 9 || a[3] != 8) { return 1 }
        0
    }
}

func t311BulkAt(a: ArrayList<Int64> @local!, source: Array<Int64> @local!): Int64 {
    exclave {
        a.add(all: source, at: 1)
        if (a.size != 4 || a[1] != 2 || a[2] != 3) { return 1 }
        0
    }
}

func t312Set(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a[0] = 9
        if (a[0] != 9 || a.size != 2) { return 1 }
        0
    }
}

func t313Remove(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let removed: Int64 @local! = a.remove(at: 1)
        if (removed != 2 || a.size != 2 || a[0] != 1 || a[1] != 3) { return 1 }
        0
    }
}


func t315RemoveIf(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.removeIf({x: Int64 @local! => x % 2 == 1})
        if (a.size != 2 || a[0] != 2 || a[1] != 4) { return 1 }
        0
    }
}

func t316Clear(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.clear()
        if (!a.isEmpty() || a.size != 0) { return 1 }
        0
    }
}

func t317Reverse(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        a.reverse()
        if (a.size != 4 || a[0] != 4 || a[3] != 1) { return 1 }
        0
    }
}

func t312StringSet(a: ArrayList<String> @local!): Int64 {
    exclave {
        let replacement: String @local! = "after"
        a[0] = replacement
        if (a.size != 2) { return 1 }
        0
    }
}

main(): Int64 {
    var failed = 0

    // T309: cap=2 no-grow plus full-capacity and cap=0 grow subpaths.
    let cap2: ArrayList<Int64> @local! = ArrayList<Int64>(2) @local!
    failed += assertEq(t309Grow(cap2), 0, "T309_cap2_add_and_grow")
    let cap0: ArrayList<Int64> @local! = ArrayList<Int64>(0) @local!
    failed += assertEq(t309Grow(cap0), 0, "T309_cap0_grow")

    // T310: Array and ArrayList sources; custom Collection positive is retained
    // in the design contract but is a blocked-source fixture in this SDK.
    let base10: Array<Int64> @local! = [1]
    let a10: ArrayList<Int64> @local! = ArrayList<Int64>(base10) @local!
    let source10: Array<Int64> @local! = [2, 3]
    failed += assertEq(t310Bulk(a10, source10), 0, "T310_bulk_array")
    let base10b: Array<Int64> @local! = [1]
    let a10b: ArrayList<Int64> @local! = ArrayList<Int64>(base10b) @local!
    let source10b: Array<Int64> @local! = [2, 3]
    let sourceList10: ArrayList<Int64> @local! = ArrayList<Int64>(source10b) @local!
    failed += assertEq(t310BulkList(a10b, sourceList10), 0, "T310_bulk_arraylist")

    // T311 scalar/bulk at boundary, including append at=size.
    let base11: Array<Int64> @local! = [1, 2]
    let a11: ArrayList<Int64> @local! = ArrayList<Int64>(base11) @local!
    failed += assertEq(t311Insert(a11), 0, "T311_scalar_at_boundaries")
    let base11b: Array<Int64> @local! = [1, 4]
    let a11b: ArrayList<Int64> @local! = ArrayList<Int64>(base11b) @local!
    let source11: Array<Int64> @local! = [2, 3]
    failed += assertEq(t311BulkAt(a11b, source11), 0, "T311_bulk_at")

    // T312-T317 doc-correct replacement/removal/range/filter/clear/reverse.
    // Range removal has a separate boundary case.
    let base12: Array<Int64> @local! = [1, 2]
    let a12: ArrayList<Int64> @local! = ArrayList<Int64>(base12) @local!
    failed += assertEq(t312Set(a12), 0, "T312_index_set")
    let base13: Array<Int64> @local! = [1, 2, 3]
    let a13: ArrayList<Int64> @local! = ArrayList<Int64>(base13) @local!
    failed += assertEq(t313Remove(a13), 0, "T313_remove_at")
    let base15: Array<Int64> @local! = [1, 2, 3, 4]
    let a15: ArrayList<Int64> @local! = ArrayList<Int64>(base15) @local!
    failed += assertEq(t315RemoveIf(a15), 0, "T315_removeIf_odd")
    let base16: Array<Int64> @local! = [1, 2]
    let a16: ArrayList<Int64> @local! = ArrayList<Int64>(base16) @local!
    failed += assertEq(t316Clear(a16), 0, "T316_clear_nonempty")
    let base17: Array<Int64> @local! = [1, 2, 3, 4]
    let a17: ArrayList<Int64> @local! = ArrayList<Int64>(base17) @local!
    failed += assertEq(t317Reverse(a17), 0, "T317_reverse_even")
    let a310e: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2]) @local!
    let empty310: Array<Int64> @local! = []
    a310e.add(all: empty310)
    if (a310e.size != 2 || a310e[1] != 2) { failed += 1; println("FAIL: T310_empty_source") }
    let a311b: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2]) @local!
    try { a311b.add(9, at: -1); failed += 1; println("FAIL: T311_at_negative") } catch (e: IndexOutOfBoundsException) {}
    try { a311b.add(9, at: 3); failed += 1; println("FAIL: T311_at_gt_size") } catch (e: IndexOutOfBoundsException) {}
    // Check owned writes and unchanged contents after rejected indices.
    let a312Owned: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2]) @local!
    a312Owned[0] = 9
    if (a312Owned[0] != 9 || a312Owned.size != 2 || a312Owned.capacity != 2) { failed += 1; println("FAIL: T312_owned_set") }
    try { a312Owned[-1] = 7; failed += 1; println("FAIL: T312_owned_set_negative") } catch (e: IndexOutOfBoundsException) {}
    try { a312Owned[2] = 7; failed += 1; println("FAIL: T312_owned_set_size") } catch (e: IndexOutOfBoundsException) {}
    if (a312Owned[0] != 9 || a312Owned[1] != 2) { failed += 1; println("FAIL: T312_owned_oob_unchanged") }
    // Check owned removal at the last, negative, and end indices.
    let a313b: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2, 3]) @local!
    let last313: Int64 @local! = a313b.remove(at: 2)
    if (last313 != 3 || a313b.size != 2) { failed += 1; println("FAIL: T313_remove_last") }
    let a313Owned: ArrayList<Int64> @local! = ArrayList<Int64>([1, 4]) @local!
    let got313: Int64 @local! = a313Owned.remove(at: 1)
    if (got313 != 4 || a313Owned.size != 1) { failed += 1; println("FAIL: T313_owned_remove") }
    try { a313Owned.remove(at: -1); failed += 1; println("FAIL: T313_remove_negative") } catch (e: IndexOutOfBoundsException) {}
    try { a313Owned.remove(at: 1); failed += 1; println("FAIL: T313_remove_size") } catch (e: IndexOutOfBoundsException) {}
    let a315k: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2, 3]) @local!
    a315k.removeIf({ v: Int64 @local! => false })
    if (a315k.size != 3 || a315k[2] != 3) { failed += 1; println("FAIL: T315_retain_all") }
    let a315d: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2, 3]) @local!
    a315d.removeIf({ v: Int64 @local! => true })
    if (a315d.size != 0) { failed += 1; println("FAIL: T315_delete_all") }
    let a315t: ArrayList<Int64> @local! = ArrayList<Int64>([1, 2, 3]) @local!
    try {
        a315t.removeIf({ v: Int64 @local! => if (v == 1) { throw IllegalArgumentException("sentinel315") } else { false } })
        failed += 1
        println("FAIL: T315_first_throw — expected sentinel propagation")
    } catch (expected315: IllegalArgumentException) {}
    // Check clear and reverse on owned and empty lists.
    let a316Owned: ArrayList<Int64> @local! = ArrayList<Int64>([5]) @local!
    a316Owned.clear()
    if (!a316Owned.isEmpty() || a316Owned.capacity != 1) { failed += 1; println("FAIL: T316_owned_clear") }
    let a316e: ArrayList<Int64> @local! = ArrayList<Int64>(2) @local!
    a316e.clear()
    if (!a316e.isEmpty() || a316e.capacity != 2) { failed += 1; println("FAIL: T316_clear_empty") }
    let a317e: ArrayList<Int64> @local! = ArrayList<Int64>(3) @local!
    a317e.reverse()
    if (!a317e.isEmpty()) { failed += 1; println("FAIL: T317_reverse_empty") }
    let strings: Array<String> @local! = ["before", "tail"]
    let stringList: ArrayList<String> @local! = ArrayList<String>(strings) @local!
    failed += assertEq(t312StringSet(stringList), 0, "T312_string_mode")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
