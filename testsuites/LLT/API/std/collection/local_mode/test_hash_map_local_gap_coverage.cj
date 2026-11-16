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
// 覆盖 hash_map.cj 中此前从未执行的 local 成员（增量覆盖率报告里 hash_map.cj
// 是最大缺口：行 22.2%、分支 7.1%）：
//   - init(this @local!, elements: Collection<(K,V)> @local!)
//   - add(this @local!, all!: Collection<(K,V)> @local!)
//   - replace(this @local!, key, value)   命中（返回旧值并覆盖）/ 未命中（返回 None）
//   - remove(this @local!, key)           命中 / 未命中，以及删除后再插入复用空闲 entry
//   - entryView(this @local!, key)        @local! 接收者返回活视图（读写穿透到 map）
//   - entryView(this @local?, key)        @local? 接收者明确拒绝
//
// 写法说明：这些调用必须在 main 中就地执行。带 @local! 形参的函数只有在返回
// 非 Copyable / @local! 时才允许 exclave，而这里断言只需 Bool/Int64；回调构造
// （size, initElement）受编译器限制无法在 lambda 内返回 @local! tuple，故单独跳过。

import std.collection.*
import std.core.*


// 自定义 Collection 夹具：HashMap 对 Array 有专用重载，只有传入"非 Array/ArrayList 的
// Collection 实现"才会进入 init(this @local!, elements: Collection<(K,V)> @local!)（L491）
// 与 add(this @local!, all!: Collection<(K,V)> @local!)（L865）这两条通用路径。
class PairCollection <: Collection<(String, Int64)> {
    let items: Array<(String, Int64)>
    init(items: Array<(String, Int64)>) { this.items = items }
    exclave init(this @local!, items: Array<(String, Int64)> @local!) { this.items = items }
    public prop size: Int64 { get() { items.size } }
    public func isEmpty(): Bool { items.size == 0 }
    public func iterator(): Iterator<(String, Int64)> { items.iterator() }
    public exclave func iterator(this @local!): Iterator<(String, Int64)> @local! { items.iterator() }
    public func toArray(): Array<(String, Int64)> { items.clone() }
    public exclave func toArray(this @local!): Array<(String, Int64)> @local! { items }
}

main(): Int64 {
    var failed = 0

    // ============ init(this @local!, elements: Collection<(K,V)> @local!) ============
    let srcPairs: Array<(String, Int64)> @local! = [("a", 1), ("b", 2), ("c", 3)]
    let collSrc: PairCollection @local! = PairCollection(srcPairs) @local!
    let asColl: Collection<(String, Int64)> @local! = collSrc
    let fromColl: HashMap<String, Int64> @local! = HashMap<String, Int64>(asColl) @local!
    failed += assertEq(fromColl.size, 3, "HM_init_from_collection_size")
    match (fromColl.get("b")) {
        case Some(v) => failed += assertEq(v, 2, "HM_init_from_collection_value")
        case None =>
            failed += 1
            println("FAIL: HM_init_from_collection_value — expected Some(2)")
    }

    // 空源构造（走 else 分支：不预置 buckets，后续首个插入触发 resize）
    let emptySrc: Array<(String, Int64)> @local! = []
    let emptyColl: PairCollection @local! = PairCollection(emptySrc) @local!
    let asEmptyColl: Collection<(String, Int64)> @local! = emptyColl
    let fromEmpty: HashMap<String, Int64> @local! = HashMap<String, Int64>(asEmptyColl) @local!
    failed += assertEq(fromEmpty.size, 0, "HM_init_from_empty_collection_size")

    // ============ add(this @local!, all!: Collection<(K,V)> @local!) ============
    let addMap: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    addMap.add("x", 1)
    let morePairs: Array<(String, Int64)> @local! = [("y", 2), ("z", 3)]
    let moreColl: PairCollection @local! = PairCollection(morePairs) @local!
    let asMoreColl: Collection<(String, Int64)> @local! = moreColl
    addMap.add(all: asMoreColl)
    failed += assertEq(addMap.size, 3, "HM_add_all_size")
    match (addMap.get("z")) {
        case Some(v) => failed += assertEq(v, 3, "HM_add_all_value")
        case None =>
            failed += 1
            println("FAIL: HM_add_all_value — expected Some(3)")
    }

    // 往已满容量的 map 上追加，触发扩容路径
    let grow: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    grow.add("k1", 1)
    grow.add("k2", 2)
    let growMore: Array<(String, Int64)> @local! = [("k3", 3), ("k4", 4)]
    let growColl: PairCollection @local! = PairCollection(growMore) @local!
    let asGrowColl: Collection<(String, Int64)> @local! = growColl
    grow.add(all: asGrowColl)
    failed += assertEq(grow.size, 4, "HM_add_all_growth_size")
    match (grow.get("k4")) {
        case Some(v) => failed += assertEq(v, 4, "HM_add_all_growth_value")
        case None =>
            failed += 1
            println("FAIL: HM_add_all_growth_value")
    }

    // ============ replace：命中（返回旧值并覆盖）============
    let rep: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    rep.add("k", 1)
    let hit: ?Int64 @local! = rep.replace("k", 9)
    match (hit) {
        case Some(old) => failed += assertEq(old, 1, "HM_replace_hit_returns_old")
        case None =>
            failed += 1
            println("FAIL: HM_replace_hit_returns_old — expected Some(1)")
    }
    match (rep.get("k")) {
        case Some(v) => failed += assertEq(v, 9, "HM_replace_hit_overwrites")
        case None =>
            failed += 1
            println("FAIL: HM_replace_hit_overwrites — expected Some(9)")
    }

    // ============ replace：未命中（返回 None，集合不变）============
    let miss: ?Int64 @local! = rep.replace("absent", 5)
    failed += assertB(miss.isNone(), "HM_replace_miss_returns_none")
    failed += assertEq(rep.size, 1, "HM_replace_miss_size_unchanged")

    // ============ remove：命中 + 未命中 + 删除后复用空闲 entry ============
    let rem: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    rem.add("a", 1)
    rem.add("b", 2)
    let gotA: Option<Int64> @local! = rem.remove("a")
    match (gotA) {
        case Some(v) => failed += assertEq(v, 1, "HM_remove_hit_returns_value")
        case None =>
            failed += 1
            println("FAIL: HM_remove_hit_returns_value — expected Some(1)")
    }
    failed += assertEq(rem.size, 1, "HM_remove_hit_size")

    let gotMiss: Option<Int64> @local! = rem.remove("absent")
    failed += assertB(gotMiss.isNone(), "HM_remove_miss_returns_none")
    failed += assertEq(rem.size, 1, "HM_remove_miss_size_unchanged")

    // 删除后再次插入：复用被回收的 entry（freeSize > 0 分支）
    rem.add("c", 3)
    rem.add("e", 4)
    failed += assertEq(rem.size, 3, "HM_remove_then_add_size")
    match (rem.get("e")) {
        case Some(v) => failed += assertEq(v, 4, "HM_remove_then_add_value")
        case None =>
            failed += 1
            println("FAIL: HM_remove_then_add_value")
    }

    // ============ entryView：@local! 返回活视图，@local? 明确拒绝 ============
    let ev: HashMap<String, Int64> @local! = HashMap<String, Int64>() @local!
    ev.add("k", 1)
    var bangLive = false
    try {
        let view: MapEntryView<String, Int64> @local! = ev.entryView("k")
        let read: ?Int64 @local! = view.value
        match (read) {
            case Some(v) => if (v == 1) { bangLive = true }
            case None => ()
        }
        // 视图是活引用：写穿后 map 本体可见
        view.value = Some(11)
        match (ev.get("k")) {
            case Some(v) => if (v != 11) { bangLive = false }
            case None => bangLive = false
        }
    } catch (e: Exception) {
        bangLive = false
    }
    failed += assertB(bangLive, "HM_entryView_local_bang_live")

    let evHalf: HashMap<String, Int64> @local? = ev
    var halfCaught = false
    try {
        let _: MapEntryView<String, Int64> @local? = evHalf.entryView("k")
    } catch (e: Exception) {
        halfCaught = true
    }
    failed += assertB(halfCaught, "HM_entryView_local_half_rejected")

    // ============ ArrayList(size, initElement) 的 @local? 构造（含 size<0 拒绝）============
    var alNegCaught = false
    try {
        let _: ArrayList<Int64> @local? = ArrayList<Int64>(-1, { i: Int64 => i }) @local?
    } catch (e: IllegalArgumentException) {
        alNegCaught = true
    }
    failed += assertB(alNegCaught, "AL_init_callback_half_negative")

    let alFromCb: ArrayList<Int64> @local? = ArrayList<Int64>(3, { i: Int64 => i }) @local?
    failed += assertEq(alFromCb.size, 3, "AL_init_callback_half_size")
    failed += assertB(alFromCb[2] == 2, "AL_init_callback_half_value")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
