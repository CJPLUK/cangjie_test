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
//
// 覆盖 map_interface.cj 的 local 默认体（throw 分支）。该文件在增量覆盖率报告里
// 长期 0%，因为此前用例都调用 HashMap 的真实覆写，接口默认体从未执行。
//
// 覆盖目标：
//   MapEntryView: key/value 的 plain、key @local?、value @local! 默认体
//   ReadOnlyMap : get/[] 的 @local! 与 @local?、contains(key)、contains(all)、
//                 keys 的 @local!/@local?、values 的 @local!/@local?
//
// 实测约束（勿再踩）：
//   1. @local!/@local? 变量不能被普通 lambda 捕获 → 断言就地 try/catch。
//   2. 局部 conformer 需同时提供 `init()` 与 `exclave init(this @local!)`。
//   3. MapEntryView 的 plain key/value 必须由 conformer 实现（接口默认体只在
//      省略时才走），因此 plain 断言用一个不实现它们的夹具。

import std.collection.*
import std.core.*

// ---------------------------------------------------------------- 夹具

// 最小 ReadOnlyMap：plain 成员全实现，local 面全部留给默认体。
class MinReadOnlyMap <: ReadOnlyMap<Int64, Int64> {
    init() {}
    exclave init(this @local!) {}
    public prop size: Int64 { get() { 0 } }
    public func isEmpty(): Bool { true }
    public func iterator(): Iterator<(Int64, Int64)> { Array<(Int64, Int64)>().iterator() }
    public func get(key: Int64): ?Int64 { None }
    public func contains(key: Int64): Bool { false }
    public func contains(all!: Collection<Int64>): Bool { false }
    public func keys(): EquatableCollection<Int64> { throw Exception("unused") }
    public func values(): Collection<Int64> { throw Exception("unused") }
    public operator func [](key: Int64): Int64 { 0 }
}

// 最小 Map：在 ReadOnlyMap 基础上补 plain add。
class MinMap <: Map<Int64, Int64> {
    init() {}
    exclave init(this @local!) {}
    public prop size: Int64 { get() { 0 } }
    public func isEmpty(): Bool { true }
    public func iterator(): Iterator<(Int64, Int64)> { Array<(Int64, Int64)>().iterator() }
    public func get(key: Int64): ?Int64 { None }
    public func contains(key: Int64): Bool { false }
    public func contains(all!: Collection<Int64>): Bool { false }
    public func keys(): EquatableCollection<Int64> { throw Exception("unused") }
    public func values(): Collection<Int64> { throw Exception("unused") }
    public operator func [](key: Int64): Int64 { 0 }
    public func add(key: Int64, value: Int64): Option<Int64> { None }
    public func add(all!: Collection<(Int64, Int64)>): Unit { }
    public func entryView(key: Int64): MapEntryView<Int64, Int64> {
        throw Exception("unused")
    }
    public func remove(key: Int64): Option<Int64> { None }
    public func remove(all!: Collection<Int64>): Unit { }
    public func removeIf(predicate: (Int64, Int64) -> Bool): Unit { }
    public func clear(): Unit { }
    public operator func [](key: Int64, value!: Int64): Unit { }
}

// 最小 MapEntryView：省略 key/value 的 plain 与 local 成员，全部落到默认体。
class MinEntryView <: MapEntryView<Int64, Int64> {
    init() {}
    exclave init(this @local!) {}
}

// 空集合夹具：用于 Map.add(all:)/remove(all:) 的 @local! 默认体调用。
exclave func emptyPairs(): Collection<(Int64, Int64)> @local! {
    let a: Array<(Int64, Int64)> @local! = []
    a
}

exclave func emptyInts(): Collection<Int64> @local! {
    let a: Array<Int64> @local! = []
    a
}

main(): Int64 {
    var failed = 0
    var hits = 0

    // ============ MapEntryView plain 默认体（key / value）============
    let view: MapEntryView<Int64, Int64> = MinEntryView()
    hits = 0
    try { let _ = view.key } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = view.value } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 2, "MI_entryview_plain_defaults_throw")

    // ============ MapEntryView @local? key 与 @local! value 默认体 ============
    let viewHalf: MapEntryView<Int64, Int64> @local? = MinEntryView()
    hits = 0
    try { let _ = viewHalf.key } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 1, "MI_entryview_half_key_default_throws")

    let viewBang: MapEntryView<Int64, Int64> @local! = MinEntryView() @local!
    hits = 0
    try { let _ = viewBang.value } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 1, "MI_entryview_bang_value_default_throws")

    // ============ ReadOnlyMap @local! 默认体：get / [] / keys / values ============
    let mapBang: ReadOnlyMap<Int64, Int64> @local! = MinReadOnlyMap() @local!
    hits = 0
    try { let _ = mapBang.get(0) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapBang[0] } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapBang.keys() } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapBang.values() } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 4, "MI_readonly_map_bang_defaults_throw")

    // ============ ReadOnlyMap @local? 默认体：get / [] / contains / keys / values ============
    let mapHalf: ReadOnlyMap<Int64, Int64> @local? = MinReadOnlyMap()
    hits = 0
    try { let _ = mapHalf.get(0) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapHalf[0] } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapHalf.contains(0) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapHalf.keys() } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapHalf.values() } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 5, "MI_readonly_map_half_defaults_throw")

    // ============ Map @local! 默认体：add×2 / remove×2 / removeIf / clear / []= ============
    let mapFullBang: Map<Int64, Int64> @local! = MinMap() @local!
    hits = 0
    try { let _ = mapFullBang.add(1, 2) } catch (e: UnimplementedException) { hits += 1 }
    try { mapFullBang.add(all: emptyPairs()) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapFullBang.remove(1) } catch (e: UnimplementedException) { hits += 1 }
    try { mapFullBang.remove(all: emptyInts()) } catch (e: UnimplementedException) { hits += 1 }
    try { mapFullBang.removeIf({ k: Int64, v: Int64 => false }) } catch (e: UnimplementedException) { hits += 1 }
    try { mapFullBang.clear() } catch (e: UnimplementedException) { hits += 1 }
    try { mapFullBang[1] = 2 } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 7, "MI_map_bang_mutators_throw")

    // ============ Map 的 entryView(@local!/@local?) / addIfAbsent / replace 默认体 ============
    hits = 0
    try { let _ = mapFullBang.entryView(1) } catch (e: UnimplementedException) { hits += 1 }
    let mapFullHalf: Map<Int64, Int64> @local? = MinMap()
    try { let _ = mapFullHalf.entryView(1) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapFullBang.addIfAbsent(1, 2) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = mapFullBang.replace(1, 2) } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 4, "MI_map_extended_defaults_throw")

    // ============ Map 的 add 覆写正常返回（对照：确认夹具本身可用）============
    let fullMap: Map<Int64, Int64> = MinMap()
    let added: Option<Int64> = fullMap.add(1, 2)
    failed += assertB(added.isNone(), "MI_min_map_add_returns_none")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
