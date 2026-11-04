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
import std.collection.concurrent.*

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkUnsupportedKey(view: MapEntryView<Int64, Int64> @local?): Unit {
    var caught = false
    try { let _ = view.key }
    catch (_: UnimplementedException) { caught = true }
    check(caught, "unadapted conformer must reject shared key access explicitly")
}

func checkHashMap(): Unit {
    let map = HashMap<Int64, Int64>()
    map.add(1, 10)
    let view: MapEntryView<Int64, Int64> = map.entryView(1)
    check(view.key == 1 && view.value.getOrThrow() == 10, "heap HashMap entry view")
    view.value = Some(20)
    check(map[1] == 20, "heap HashMap setter")
    view.value = None
    check(!map.contains(1), "heap HashMap removal")
}

func checkTreeMap(): Unit {
    let map = TreeMap<Int64, Int64>()
    map.add(1, 10)
    let view: MapEntryView<Int64, Int64> = map.entryView(1)
    check(view.key == 1 && view.value.getOrThrow() == 10, "heap TreeMap entry view")
    checkUnsupportedKey(view)
    view.value = Some(20)
    check(map[1] == 20, "heap TreeMap setter remains available")
    view.value = None
    check(!map.contains(1), "heap TreeMap removal")
}

func checkConcurrentMap(): Unit {
    let map = ConcurrentHashMap<Int64, Int64>()
    map.add(1, 10)
    map.entryView(1, {view =>
        check(view.key == 1 && view.value.getOrThrow() == 10, "heap concurrent entry view")
        checkUnsupportedKey(view)
        view.value = Some(20)
    })
    check(map[1] == 20, "concurrent entry view update")
    map.entryView(1, {view => view.value = None})
    check(!map.contains(1), "concurrent entry view removal")
}

main(): Int64 {
    checkHashMap()
    checkTreeMap()
    checkConcurrentMap()
    println("ALL PASSED")
    0
}
