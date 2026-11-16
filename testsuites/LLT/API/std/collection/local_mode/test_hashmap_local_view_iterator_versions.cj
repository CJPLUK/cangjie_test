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

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

exclave func expectOwnedInvalidated<T>(iterator: Iterator<T> @local!): Unit {
    var caught = false
    try { let _ = iterator.next() }
    catch (_: ConcurrentModificationException) { caught = true }
    check(caught, "owned view iterator must detect structural changes")
}

func expectSharedInvalidated<T>(iterator: Iterator<T> @local?): Unit {
    var caught = false
    try { let _ = iterator.next() }
    catch (_: ConcurrentModificationException) { caught = true }
    check(caught, "shared view iterator must detect structural changes")
}

func checkStructuralChange(action: Int64): Unit {
    let map: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    if (action != 3) { map.add("a", 10); map.add("bb", 20) }
    let shared: HashMap<String, Int64> @local? = map
    let keys: Iterator<String> @local! = map.keys().iterator()
    let values: Iterator<Int64> @local! = map.values().iterator()
    let sharedKeys: Iterator<String> @local? = shared.keys().iterator()
    let sharedValues: Iterator<Int64> @local? = shared.values().iterator()
    let direct: Iterator<(String, Int64)> @local! = map.iterator()
    if (action == 0 || action == 3) { map.add("ccc", 30) }
    else if (action == 1) { map.remove("a") }
    else { map.clear() }
    var caught = false
    try { let _ = direct.next() }
    catch (_: ConcurrentModificationException) { caught = true }
    check(caught, "direct iterator control")
    expectOwnedInvalidated(keys)
    expectOwnedInvalidated(values)
    expectSharedInvalidated(sharedKeys)
    expectSharedInvalidated(sharedValues)
}

func checkUnchangedVersion(): Unit {
    let map: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    map.add("a", 10)
    let keys: Iterator<String> @local! = map.keys().iterator()
    let values: Iterator<Int64> @local! = map.values().iterator()
    map.add("a", 20)
    map.remove("missing")
    check(keys.next().getOrThrow() == "a", "value replacement must not invalidate keys")
    check(values.next().getOrThrow() == 20, "value replacement must remain visible")
    check(keys.next().isNone() && values.next().isNone(), "view exhaustion")
}

func keySize(value: Option<String> @local?): Int64 {
    match (value) {
        case Some(key) => key.size
        case None => throw Exception("missing key")
    }
}

func intValue(value: Option<Int64> @local?): Int64 {
    match (value) {
        case Some(item) => item
        case None => throw Exception("missing value")
    }
}

func checkHoles(): Unit {
    let map: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    map.add("a", 10); map.add("bb", 20); map.add("ccc", 30)
    map.remove("bb")
    let shared: HashMap<String, Int64> @local? = map
    let keys: Iterator<String> @local? = shared.keys().iterator()
    let values: Iterator<Int64> @local? = shared.values().iterator()
    let keySum = keySize(keys.next()) + keySize(keys.next())
    let valueSum = intValue(values.next()) + intValue(values.next())
    check(keySum == 4 && valueSum == 40, "view iterators must skip deleted slots")
    check(keys.next().isNone() && keys.next().isNone(), "keys remain exhausted")
    check(values.next().isNone() && values.next().isNone(), "values remain exhausted")
}

main(): Int64 {
    checkUnchangedVersion()
    checkHoles()
    for (action in 0..4) { checkStructuralChange(action) }
    println("ALL PASSED")
    0
}
