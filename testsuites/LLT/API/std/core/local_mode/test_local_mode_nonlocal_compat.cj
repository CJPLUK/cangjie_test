/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖设计项（LM-DOC-20260910）：T400,T415。

import std.collection.*

class T400CompatIterator <: Iterator<String> {
    private let values: Array<String>
    private var index: Int64 = 0

    init() {
        values = ["a", "b"]
    }

    public func next(): Option<String> {
        if (index < values.size) {
            let result = values[index]
            index += 1
            Some(result)
        } else {
            None
        }
    }
}

class T400CompatIterable <: Iterable<String> {
    public func iterator(): Iterator<String> {
        T400CompatIterator()
    }
}


main(): Int64 {
    var failed = 0

    // T400: Iterable<String> 的原始 iterator/next 经接口静态接收者动态分派。
    let iterable: Iterable<String> = T400CompatIterable()
    let iterator: Iterator<String> = iterable.iterator()
    failed += assertEq(iterator.next(), Some("a"), "T400_iterable_next_a")
    failed += assertEq(iterator.next(), Some("b"), "T400_iterable_next_b")
    failed += assertEq(iterator.next(), None, "T400_iterable_next_none")

    // T415-1: List<String>.add(T)
    let addOne: List<String> = ArrayList<String>(["b", "d"])
    addOne.add("e")
    failed += assertEq(addOne.size, 3, "T415_add_one_size")
    failed += assertEq(addOne[0], "b", "T415_add_one_0")
    failed += assertEq(addOne[1], "d", "T415_add_one_1")
    failed += assertEq(addOne[2], "e", "T415_add_one_2")

    // T415-2: List<String>.add(all: Collection<T>)
    let addAll: List<String> = ArrayList<String>(["b", "d"])
    let sourceAll: Collection<String> = ArrayList<String>(["f", "g"])
    addAll.add(all: sourceAll)
    failed += assertEq(addAll.size, 4, "T415_add_all_size")
    failed += assertEq(addAll[0], "b", "T415_add_all_0")
    failed += assertEq(addAll[1], "d", "T415_add_all_1")
    failed += assertEq(addAll[2], "f", "T415_add_all_2")
    failed += assertEq(addAll[3], "g", "T415_add_all_3")

    // T415-3: List<String>.add(T, at:)
    let addAt: List<String> = ArrayList<String>(["b", "d"])
    addAt.add("a", at: 0)
    failed += assertEq(addAt.size, 3, "T415_add_at_size")
    failed += assertEq(addAt[0], "a", "T415_add_at_0")
    failed += assertEq(addAt[1], "b", "T415_add_at_1")
    failed += assertEq(addAt[2], "d", "T415_add_at_2")

    // T415-4: List<String>.add(all: Collection<T>, at:)
    let addAllAt: List<String> = ArrayList<String>(["b", "d"])
    let sourceAllAt: Collection<String> = ArrayList<String>(["c", "e"])
    addAllAt.add(all: sourceAllAt, at: 1)
    failed += assertEq(addAllAt.size, 4, "T415_add_all_at_size")
    failed += assertEq(addAllAt[0], "b", "T415_add_all_at_0")
    failed += assertEq(addAllAt[1], "c", "T415_add_all_at_1")
    failed += assertEq(addAllAt[2], "e", "T415_add_all_at_2")
    failed += assertEq(addAllAt[3], "d", "T415_add_all_at_3")

    // T415-5: List<String>.remove(at:)
    let removeAt: List<String> = ArrayList<String>(["b", "d"])
    let removed: String = removeAt.remove(at: 0)
    failed += assertEq(removed, "b", "T415_remove_at_value")
    failed += assertEq(removeAt.size, 1, "T415_remove_at_size")
    failed += assertEq(removeAt[0], "d", "T415_remove_at_remaining")

    // T415-6: List<String>.remove(Range<Int64>)
    let removeRange: List<String> = ArrayList<String>(["b", "d"])
    removeRange.remove(0..1)
    failed += assertEq(removeRange.size, 1, "T415_remove_range_size")
    failed += assertEq(removeRange[0], "d", "T415_remove_range_remaining")

    // T415-7: List<String>.removeIf((String) -> Bool)
    let removeIf: List<String> = ArrayList<String>(["b", "d"])
    removeIf.removeIf({value => value == "b"})
    failed += assertEq(removeIf.size, 1, "T415_remove_if_size")
    failed += assertEq(removeIf[0], "d", "T415_remove_if_remaining")

    // T415-8: List<String>.clear()
    let clearList: List<String> = ArrayList<String>(["b", "d"])
    clearList.clear()
    failed += assertEq(clearList.size, 0, "T415_clear_size")
    failed += assertB(clearList.isEmpty(), "T415_clear_empty")

    // T415-9: List<String>.[](index)=(value)
    let setList: List<String> = ArrayList<String>(["b", "d"])
    setList[1] = "z"
    failed += assertEq(setList.size, 2, "T415_set_size")
    failed += assertEq(setList[0], "b", "T415_set_0")
    failed += assertEq(setList[1], "z", "T415_set_1")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
