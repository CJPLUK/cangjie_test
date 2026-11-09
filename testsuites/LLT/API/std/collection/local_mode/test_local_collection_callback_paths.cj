/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.collection.*

class Calls {
    var count: Int64 = 0
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkMapShortCircuits(): Unit {
    let map: HashMap<Int64, Int64> @local! = HashMap<Int64, Int64>() @local!
    let view: HashMap<Int64, Int64> @local? = map
    let calls = Calls()
    check(view.all({_, _ => calls.count++; false}), "empty all")
    check(!view.any({_, _ => calls.count++; true}), "empty any")
    check(view.none({_, _ => calls.count++; true}), "empty none")
    check(calls.count == 0, "empty predicates must not execute")
    map.add(1, 10); map.add(2, 20); map.add(3, 30)
    check(!view.all({_, _ => calls.count++; calls.count < 2}), "all short circuit")
    check(calls.count == 2, "all callback count")
    calls.count = 0
    check(view.any({_, _ => calls.count++; calls.count == 2}), "any short circuit")
    check(calls.count == 2, "any callback count")
    calls.count = 0
    check(!view.none({_, _ => calls.count++; calls.count == 2}), "none short circuit")
    check(calls.count == 2, "none callback count")
    calls.count = 0
    var caught = false
    try {
        let _ = map.mapValues({value: Int64 @local? =>
            calls.count++
            if (calls.count == 2) { throw ArithmeticException("map sentinel") }
            value
        })
    } catch (e: ArithmeticException) { caught = e.message == "map sentinel" }
    check(caught && calls.count == 2, "map callback exception and stop point")
    check(map.size == 3 && map[1] == 10 && map[2] == 20 && map[3] == 30, "mapValues must preserve its source")
}

func checkRemovalExceptions(): Unit {
    let calls = Calls()
    let list: ArrayList<Int64> @local! = ArrayList<Int64>() @local!
    list.add(1); list.add(2); list.add(3)
    var caught = false
    try {
        list.removeIf({value: Int64 @local! =>
            calls.count++
            if (value == 3) { throw ArithmeticException("list sentinel") }
            value == 1
        })
    } catch (e: ArithmeticException) { caught = e.message == "list sentinel" }
    check(caught && calls.count == 3, "list predicate exception and stop point")
    // removeIf does not promise rollback; the container must remain usable.
    list.clear(); list.add(9)
    check(list.size == 1 && list[0] == 9, "list remains usable after a predicate exception")
    let map: HashMap<Int64, Int64> @local! = HashMap<Int64, Int64>() @local!
    map.add(1, 10); map.add(2, 20); map.add(3, 30)
    calls.count = 0
    caught = false
    try {
        map.removeIf({_: Int64 @local?, _: Int64 @local? =>
            calls.count++
            if (calls.count == 2) { throw ArithmeticException("remove sentinel") }
            true
        })
    } catch (e: ArithmeticException) { caught = e.message == "remove sentinel" }
    check(caught && calls.count == 2 && map.size == 2, "map removal preserves completed work before an exception")
    var count = 0
    for ((_, _) in map) { count++ }
    check(count == map.size, "map iteration agrees after an exception")
    map.clear(); map.add(9, 90)
    check(map.size == 1 && map[9] == 90, "map remains usable after a predicate exception")
}

main(): Int64 {
    checkMapShortCircuits()
    checkRemovalExceptions()
    println("ALL PASSED")
    0
}
