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
// T318: a custom Collection reaches the bulk-append path of an ArrayList @local!.
// CJEEP-005 keeps the modifier forms on the ArrayList class body as @local!, so the
// source collection is passed as @local!; a @local? source is not part of the
// baseline surface and is covered by test_arraylist_local_zip_neg_q_other.cj for the
// neighbouring zip signature.
import std.collection.*
import std.core.*

class LocalNumbers <: Collection<Int64> {
    let items: Array<Int64>
    init(items: Array<Int64>) { this.items = items }
    exclave init(this @local!, items: Array<Int64> @local!) { this.items = items }
    public prop size: Int64 { get() { items.size } }
    public func isEmpty(): Bool { items.isEmpty() }
    public func isEmpty(this @local?): Bool { items.isEmpty() }
    public func iterator(): Iterator<Int64> { items.iterator() }
    public exclave func iterator(this @local!): Iterator<Int64> @local! { items.iterator() }
    public func toArray(): Array<Int64> { items.clone() }
    public func toArray(this @local!): Array<Int64> @local! { items }
}

func t318AddAll(list: ArrayList<Int64> @local!, source: Collection<Int64> @local!): Int64 {
    exclave {
        list.add(all: source)
        if (list.size != 4 || list[0] != 1 || list[1] != 4 || list[2] != 2 || list[3] != 3) { return 1 }
        0
    }
}

main(): Int64 {
    var failed = 0
    let data: Array<Int64> @local! = [2, 3]
    let source: LocalNumbers @local! = LocalNumbers(data) @local!
    let initial: ArrayList<Int64> @local! = ArrayList<Int64>(8) @local!
    initial.add(1)
    initial.add(4)
    failed += assertEq(t318AddAll(initial, source), 0, "T318_add_all_custom_local")
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
