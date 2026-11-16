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
// Collection constructors copy Array and ArrayList sources and use local toArray for other sources.

import std.collection.*
import std.core.*

class GaHeapCollection <: Collection<Int64> {
    let items: Array<Int64>
    init(items: Array<Int64>) { this.items = items }
    public func iterator(): Iterator<Int64> { items.iterator() }
    public prop size: Int64 {
        get() { items.size }
    }
    public func isEmpty(): Bool { items.size == 0 }
    public func toArray(): Array<Int64> { items }
}

// A custom collection with a local toArray implementation.
class GaLocalCollection <: Collection<Int64> {
    let items: Array<Int64>
    init(items: Array<Int64>) { this.items = items }
    public func iterator(): Iterator<Int64> { items.iterator() }
    public prop size: Int64 {
        get() { items.size }
    }
    public func isEmpty(): Bool { items.size == 0 }
    public func toArray(): Array<Int64> { items.clone() }
    public func toArray(this @local?): Array<Int64> @local? {
        exclave { items.clone() }
    }
}

main(): Int64 {
    var failed = 0
    let sourceArray: Array<Int64> @local! = [1, 2]
    let arrayCollection: Collection<Int64> @local? = sourceArray
    let fromArray: ArrayList<Int64> @local? = ArrayList<Int64>(arrayCollection) @local?
    failed += assertEq(fromArray.size, 2, "GA17_init_local_q_from_array_size")
    failed += assertEq(fromArray[0], 1, "GA17_init_local_q_from_array_elem0")
    failed += assertEq(fromArray[1], 2, "GA17_init_local_q_from_array_elem1")

    let sourceList: ArrayList<Int64> @local! = ArrayList<Int64>(8) @local!
    sourceList.add(3)
    sourceList.add(4)
    let listCollection: Collection<Int64> @local? = sourceList
    let fromList: ArrayList<Int64> @local? = ArrayList<Int64>(listCollection) @local?
    failed += assertEq(fromList.size, 2, "GA17_init_local_q_from_list_size")
    failed += assertEq(fromList[0], 3, "GA17_init_local_q_from_list_elem0")
    failed += assertEq(fromList[1], 4, "GA17_init_local_q_from_list_elem1")

    let heapCustom = GaHeapCollection([5, 6])
    let qCustom: Collection<Int64> @local? = heapCustom
    // The default local toArray implementation must throw.
    var defaultThrew = false
    try {
        let _ = ArrayList<Int64>(qCustom) @local?
    } catch (e: UnimplementedException) {
        defaultThrew = true
    }
    failed += assertB(defaultThrew, "GA17_init_local_q_custom_default_throw")

    // A custom local toArray implementation supports construction.
    let localCustom: Collection<Int64> @local? = GaLocalCollection([7, 8])
    let fromLocalCustom: ArrayList<Int64> @local? = ArrayList<Int64>(localCustom) @local?
    failed += assertEq(fromLocalCustom.size, 2, "GA17_init_local_q_custom_local_size")
    failed += assertEq(fromLocalCustom[0], 7, "GA17_init_local_q_custom_local_elem0")
    failed += assertEq(fromLocalCustom[1], 8, "GA17_init_local_q_custom_local_elem1")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
