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

struct CollisionKey <: Copyable & Hashable & Equatable<CollisionKey> {
    let id: Int64
    init(id: Int64) { this.id = id }
    public func hashCode(): Int64 { 7 }
    public func hashCode(this @local?): Int64 { 7 }
    public func hashCode(this @local!): Int64 { 7 }
    public operator func ==(other: CollisionKey): Bool { id == other.id }
    public operator func ==(this @local?, other: CollisionKey @local?): Bool { id == other.id }
    public operator func ==(this @local!, other: CollisionKey @local!): Bool { id == other.id }
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func intValue(value: Option<Int64> @local?): Int64 {
    match (value) {
        case Some(item) => item
        case None => throw Exception("missing value")
    }
}

func checkConstantHashChain(): Unit {
    let map: HashMap<CollisionKey, Int64> @local! = HashMap<CollisionKey, Int64>(8) @local!
    for (i in 1..=4) { map.add(CollisionKey(i), i * 10) }
    for (i in 1..=4) { check(map[CollisionKey(i)] == i * 10, "collision chain lookup") }
    check(!map.contains(CollisionKey(99)), "same hash with missing key")
    check(map.remove(CollisionKey(3)).getOrThrow() == 30, "remove middle of collision chain")
    check(map.remove(CollisionKey(4)).getOrThrow() == 40, "remove collision chain head")
    check(map.remove(CollisionKey(1)).getOrThrow() == 10, "remove collision chain tail")
    check(map.size == 1 && map[CollisionKey(2)] == 20, "surviving collision entry")
    let capacity = map.capacity
    map.add(CollisionKey(5), 50)
    check(map.capacity == capacity && map.size == 2, "reuse deleted entry slot")
    check(map.addIfAbsent(CollisionKey(2), 99).getOrThrow() == 20, "addIfAbsent present")
    check(map[CollisionKey(2)] == 20, "addIfAbsent must preserve existing value")
    check(map.addIfAbsent(CollisionKey(6), 60).isNone(), "addIfAbsent missing")
    check(map.replace(CollisionKey(5), 55).getOrThrow() == 50, "replace returns old value")
    check(map.replace(CollisionKey(99), 99).isNone(), "replace missing")
    check(map.size == 3 && map[CollisionKey(5)] == 55, "replace preserves map size")
    map.reserve(100)
    check(map[CollisionKey(2)] == 20 && map[CollisionKey(5)] == 55 && map[CollisionKey(6)] == 60,
        "rehash must retain live collision entries")
    check(!map.contains(CollisionKey(1)) && !map.contains(CollisionKey(3)), "rehash must skip deleted entries")
    var count = 0
    var sum = 0
    for ((_, value) in map) { count++; sum += value }
    check(count == 3 && sum == 135, "iteration after slot reuse and rehash")
    map.clear()
    map.add(CollisionKey(9), 90)
    check(map.size == 1 && map[CollisionKey(9)] == 90, "clear resets reusable state")
}

func checkDifferentHashesInOneBucket(): Unit {
    let map: HashMap<Int64, Int64> @local! = HashMap<Int64, Int64>(16) @local!
    map.add(1, 10); map.add(17, 20); map.add(33, 30)
    let view: HashMap<Int64, Int64> @local? = map
    check(intValue(view.get(1)) == 10 && intValue(view.get(17)) == 20,
        "distinct hashes sharing a bucket")
    check(view.get(49).isNone(), "absent hash in occupied bucket")
    map.remove(17)
    check(map[1] == 10 && map[33] == 30 && !view.contains(17), "unlink a distinct-hash middle entry")
}

main(): Int64 {
    checkConstantHashChain()
    checkDifferentHashesInOneBucket()
    println("ALL PASSED")
    0
}
