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
// 覆盖 list_interface.cj / map_interface.cj 的 local 默认体（throw 分支）。
//
// 这两个文件在增量覆盖率报告里长期 0%，原因不是"没测"，而是此前所有用例都调用
// HashMap / ArrayList 的**真实覆写**，接口默认体从未被执行。要覆盖默认体，必须
// 构造一个只实现 plain 必需面、**故意省略** local 成员与可省略 plain 成员的
// conformer，再通过接口静态接收者调用，观察精确的 UnimplementedException。
//
// 实测约束（勿再踩）：
//   1. @local!/@local? 变量不能被普通 lambda 捕获，因此断言必须就地 try/catch，
//      不能抽成 `filter { => ... }` 那样的 helper。
//   2. conformer 若自己实现了 plain `first`/`last`，plain 默认体就永远不会执行；
//      想覆盖 plain 默认体必须省略这两个属性。
//   3. 局部 conformer 需要 `init()` 与 `exclave init(this @local!)` 才能构造
//      @local! 实例；只给 plain init 会报 no matching constructor。

import std.collection.*
import std.core.*

// ---------------------------------------------------------------- 夹具

// ReadOnlyList 最小面：省略 plain first/last（只有默认体可走）。
class MinReadOnlyList <: ReadOnlyList<Int64> {
    init() {}
    exclave init(this @local!) {}
    public prop size: Int64 { get() { 0 } }
    public func isEmpty(): Bool { true }
    public func iterator(): Iterator<Int64> { Array<Int64>().iterator() }
    public func get(index: Int64): ?Int64 { None }
    public operator func [](index: Int64): Int64 { 0 }
}

// List 最小面：plain 全给实现，local 面全部留给默认体。
class MinList <: List<Int64> {
    init() {}
    exclave init(this @local!) {}
    public prop size: Int64 { get() { 0 } }
    public func isEmpty(): Bool { true }
    public func iterator(): Iterator<Int64> { Array<Int64>().iterator() }
    public func get(index: Int64): ?Int64 { None }
    public operator func [](index: Int64): Int64 { 0 }
    public prop first: ?Int64 { get() { None } }
    public prop last: ?Int64 { get() { None } }
    public func add(element: Int64): Unit { }
    public func add(all!: Collection<Int64>): Unit { }
    public func add(element: Int64, at!: Int64): Unit { }
    public func add(all!: Collection<Int64>, at!: Int64): Unit { }
    public func remove(at!: Int64): Int64 { 0 }
    public func remove(range: Range<Int64>): Unit { }
    public func removeIf(predicate: (Int64) -> Bool): Unit { }
    public func clear(): Unit { }
    public operator func [](index: Int64, value!: Int64): Unit { }
}

main(): Int64 {
    var failed = 0
    var hits = 0

    // ============ ReadOnlyList plain 默认体（first / last）============
    let ro: ReadOnlyList<Int64> = MinReadOnlyList()
    hits = 0
    try { let _ = ro.first } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = ro.last } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 2, "LI_readonly_plain_first_last_default_throws")

    // ============ ReadOnlyList @local! 默认体（get / [] / first / last）============
    let roBang: ReadOnlyList<Int64> @local! = MinReadOnlyList()
    hits = 0
    try { let _ = roBang.get(0) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = roBang[0] } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = roBang.first } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = roBang.last } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 4, "LI_readonly_bang_defaults_throw")

    // ============ ReadOnlyList @local? 默认体 ============
    let roHalf: ReadOnlyList<Int64> @local? = MinReadOnlyList()
    hits = 0
    try { let _ = roHalf.get(0) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = roHalf[0] } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = roHalf.first } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = roHalf.last } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 4, "LI_readonly_half_defaults_throw")

    // ============ List @local! 默认体（add×4 / remove×2 / removeIf / clear / []=）============
    let listBang: List<Int64> @local! = MinList() @local!
    hits = 0
    try { listBang.add(1) } catch (e: UnimplementedException) { hits += 1 }
    try { listBang.add(1, at: 0) } catch (e: UnimplementedException) { hits += 1 }
    try { let _ = listBang.remove(at: 0) } catch (e: UnimplementedException) { hits += 1 }
    try { listBang.remove(0..1) } catch (e: UnimplementedException) { hits += 1 }
    try { listBang.removeIf({ x: Int64 => x > 0 }) } catch (e: UnimplementedException) { hits += 1 }
    try { listBang.clear() } catch (e: UnimplementedException) { hits += 1 }
    try { listBang[0] = 9 } catch (e: UnimplementedException) { hits += 1 }
    failed += assertEq(hits, 7, "LI_list_bang_defaults_throw")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
