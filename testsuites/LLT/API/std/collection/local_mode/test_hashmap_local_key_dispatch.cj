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

class DispatchCalls {
    var plain: Int64 = 0
    var owned: Int64 = 0
    var sharedHash: Int64 = 0
    var sharedEquality: Int64 = 0

    func reset(): Unit { plain = 0; owned = 0; sharedHash = 0; sharedEquality = 0 }
}

let calls = DispatchCalls()

struct TrackedKey <: Copyable & Hashable & Equatable<TrackedKey> {
    let id: Int64
    init(id: Int64) { this.id = id }
    public func hashCode(): Int64 { calls.plain++; id }
    public func hashCode(this @local!): Int64 { calls.owned++; id }
    public func hashCode(this @local?): Int64 { calls.sharedHash++; id }
    public operator func ==(other: TrackedKey): Bool { calls.plain++; id == other.id }
    public operator func ==(this @local!, other: TrackedKey @local!): Bool { calls.owned++; id == other.id }
    public operator func ==(this @local?, other: TrackedKey @local?): Bool {
        calls.sharedEquality++
        id == other.id
    }
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkSharedDispatch(requireEquality: Bool): Unit {
    check(calls.plain == 0 && calls.owned == 0, "lookup must use shared key callbacks")
    check(calls.sharedHash > 0, "shared key hash callback must run")
    if (requireEquality) { check(calls.sharedEquality > 0, "shared key equality callback must run") }
}

main(): Int64 {
    let map: HashMap<TrackedKey, Int64> @local! = HashMap<TrackedKey, Int64>() @local!
    map.add(TrackedKey(1), 10)
    calls.reset()
    check(map.add(TrackedKey(1), 20).getOrThrow() == 10, "owned replacement returns previous value")
    checkSharedDispatch(true)
    let view: HashMap<TrackedKey, Int64> @local? = map
    calls.reset()
    match (view.get(TrackedKey(1))) {
        case Some(value) => check(value == 20, "shared get payload")
        case None => throw Exception("shared key missing")
    }
    checkSharedDispatch(true)
    calls.reset()
    check(!view.contains(TrackedKey(2)), "shared lookup miss")
    checkSharedDispatch(false)
    let keys: EquatableCollection<TrackedKey> @local? = view.keys()
    calls.reset()
    check(keys.contains(TrackedKey(1)), "keys view lookup")
    checkSharedDispatch(true)
    calls.reset()
    check(map.remove(TrackedKey(1)).getOrThrow() == 20, "removal payload")
    checkSharedDispatch(true)
    check(map.isEmpty(), "removal final state")
    println("ALL PASSED")
    0
}
