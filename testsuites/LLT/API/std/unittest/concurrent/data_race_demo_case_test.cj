/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 3

// Reproduces the data races of the OHOS demo project in
// temp/CangjieDemoCase/DataRaceCase/entry/src/main/cangjie/{data.cj,index.cj}
// as a host-runnable LLT under the stdx.unittest.concurrent framework.
//
// The Data class below is copied verbatim from the demo's data.cj with two
// changes so it links outside OHOS:
//   - the `import ohos.hilog.Hilog` line is dropped and every Hilog call is
//     commented out (Hilog is an OHOS-only kit);
//   - the `sleep(Duration.millisecond * 800)` inside getData() is removed
//     (the framework's per-iteration random backoff + high iteration counts
//     replace the demo's artificial sleeps — see scenario_runner.cj:42
//     updateBackoffSigma / :291 performBackoff).
// The race surface (unsynchronized concurrent add / remove(at:) / clear on
// the shared ArrayList<String> field `data`, plus the non-atomic `flag`) is
// otherwise identical to the demo.
//
// Three cases:
//   1. The race detected via Linearizability consistency-model validation,
//      with actors that mirror the demo's doRefresh (clear + add loop) and
//      doGrab (remove loop) operating through Data.updateData / Data.data.
//   2. The race detected via a post-iteration verify on a shared Data
//      instance, with actors that call Data.getData / Data.updateData
//      exactly as the demo's index.cj button handlers do.
//   3. A control: the same operations on a Mutex-synchronized wrapper around
//      the verbatim Data class are linearizable, proving the framework only
//      flags the unsynchronized variant.

import stdx.unittest.concurrent.*
import std.sync.Mutex
import std.collection.ArrayList


// ----- verbatim copy of temp/CangjieDemoCase/.../data.cj (sleep removed,
//       Hilog calls commented out) ----------------------------------------

// 数据更新操作类型：用于 updateData 方法区分添加 / 删除
public enum UpdateOp {
    | Add
    | Remove
}

/**
 * Data 类：共享数据容器，用于演示「并发数据竞争」场景。
 *
 * - data: ArrayList<String> 共享数据，会被多个线程并发读写
 * - flag: 初始化标志，控制 getData 是否可用（初始为 false）
 *
 * 注意：本类故意不做任何同步保护，从而让「刷新数据」与「抢单」
 * 两个线程在并发操作 data 时产生数据竞争（可能的异常、数据错乱等）。
 */
public class Data {
    var data = ArrayList<String>()
    var flag = false

    public init() {}

    // 方法 1：初始化，将 flag 设置为 true
    public func initialize(): Unit {
        flag = true
        // Hilog.info(0xABCD, "DataRace", "Data.initialize: flag set to true")
    }

    // 方法 2：获取网络数据（mock），返回一个新的 ArrayList data1
    // 如果 flag 为 false，则返回 None
    public func getData(): ?ArrayList<String> {
        if (!flag) {
            // Hilog.warn(0xABCD, "DataRace", "Data.getData: flag is false, return None")
            return None
        }
        // Hilog.info(0xABCD, "DataRace", "Data.getData: start mock network request...")
        // mock 网络请求耗时，增大并发窗口
        // sleep(Duration.millisecond * 800)
        let data1 = ArrayList<String>()
        for (i in 0..8) {
            data1.add("网络数据-${i}")
        }
        // Hilog.info(0xABCD, "DataRace", "Data.getData: mock network done, got ${data1.size} items")
        return data1
    }

    // 方法 3：根据参数更新 data 元素
    // op == Add: 将 value 添加到 data 尾部
    // op == Remove: 删除 data 中第一个等于 value 的元素
    public func updateData(op: UpdateOp, value: String): Unit {
        match (op) {
            case Add =>
                data.add(value)
                // Hilog.info(0xABCD, "DataRace", "Data.updateData Add: '${value}', size=${data.size}")
            case Remove =>
                var i: Int64 = 0
                while (i < data.size) {
                    if (data[i] == value) {
                        let removed = data.remove(at: i)
                        // Hilog.info(0xABCD, "DataRace", "Data.updateData Remove: '${removed}', size=${data.size}")
                        return
                    }
                    i = i + 1
                }
                // Hilog.warn(0xABCD, "DataRace", "Data.updateData Remove: '${value}' not found, size=${data.size}")
        }
    }
}


// ----- synchronized wrapper around the verbatim Data class, used only by
//       the control case (3) to prove the framework does not false-positive
//       on properly synchronized access -------------------------------

class SyncedData {
    let lock = Mutex()
    let inner = Data()
    public init() {
        inner.initialize()
    }
    public func clear(): Int64 {
        synchronized(lock) {
            inner.data.clear()
            inner.data.size
        }
    }
    public func add(s: String): Int64 {
        synchronized(lock) {
            inner.updateData(UpdateOp.Add, s)
            inner.data.size
        }
    }
    public func remove(s: String): Int64 {
        synchronized(lock) {
            inner.updateData(UpdateOp.Remove, s)
            inner.data.size
        }
    }
}


@Test
class DataRaceDemoCaseTests {

    // Case 1 — the demo's exact race (doRefresh's clear + add loop vs
    // doGrab's remove loop, all via Data.updateData / Data.data on a shared
    // unsynchronized ArrayList<String>) detected via Linearizability
    // consistency-model validation. Each iteration gets a fresh, pre-
    // initialized Data instance. Each operation returns data.size as an
    // observable Int64; torn reads/writes produce sizes no single sequential
    // execution can reproduce, so the scenario fails linearization.
    @TestCase
    func testDataRaceLinearizability(): Unit {
        let result = scenario("demo_data_race_linearizability")
            .withState { =>
                let d = Data()
                d.initialize()
                d
            }
            .consistencyModel(Linearizability)
            .actorWithOps([
                operation("clear")    { d => d.data.clear(); d.data.size },
                operation("add_0")    { d => d.updateData(UpdateOp.Add, "网络数据-0"); d.data.size },
                operation("add_1")    { d => d.updateData(UpdateOp.Add, "网络数据-1"); d.data.size },
                operation("add_2")    { d => d.updateData(UpdateOp.Add, "网络数据-2"); d.data.size },
                operation("add_3")    { d => d.updateData(UpdateOp.Add, "网络数据-3"); d.data.size },
                operation("add_4")    { d => d.updateData(UpdateOp.Add, "网络数据-4"); d.data.size },
                operation("add_5")    { d => d.updateData(UpdateOp.Add, "网络数据-5"); d.data.size },
                operation("add_6")    { d => d.updateData(UpdateOp.Add, "网络数据-6"); d.data.size },
                operation("add_7")    { d => d.updateData(UpdateOp.Add, "网络数据-7"); d.data.size },
            ])
            .actorWithOps([
                operation("remove_0") { d => d.updateData(UpdateOp.Remove, "网络数据-0"); d.data.size },
                operation("remove_2") { d => d.updateData(UpdateOp.Remove, "网络数据-2"); d.data.size },
                operation("remove_4") { d => d.updateData(UpdateOp.Remove, "网络数据-4"); d.data.size },
                operation("remove_6") { d => d.updateData(UpdateOp.Remove, "网络数据-6"); d.data.size },
            ])
            .iterations(2000)
            .build()
            .run()

        println(result.report())
        @Assert(!result.passed)
    }

    // Case 2 — the same race detected via a post-iteration verify on a
    // shared Data instance. The actors mirror the demo's index.cj button
    // handlers exactly: doRefresh calls getData() -> data.clear() ->
    // updateData(Add, item) for each returned item; doGrab calls
    // updateData(Remove, "网络数据-${i}") for even i. After a clean run
    // (8 adds - 4 removes) data.size == 4; lost adds or throws from
    // remove(at:) on a concurrently-cleared list leave size != 4.
    var sharedData = Data()

    @TestCase
    func testDataRaceByVerify(): Unit {
        let result = scenario("demo_data_race_verify")
            .reset { =>
                sharedData.data.clear()
                sharedData.initialize()
            }
            .actor { =>
                if (let Some(data1) <- sharedData.getData()) {
                    sharedData.data.clear()
                    for (item in data1) {
                        sharedData.updateData(UpdateOp.Add, item)
                    }
                }
            }
            .actor { =>
                for (i in 0..8 : 2) {
                    sharedData.updateData(UpdateOp.Remove, "网络数据-${i}")
                }
            }
            .verify { => sharedData.data.size == 4 }
            .iterations(100)
            .build()
            .run()

        println(result.report())
        @Assert(!result.passed)
    }

    // Case 3 (control) — the same operation sequences on a Mutex-synchronized
    // wrapper around the verbatim Data class are linearizable: the framework
    // correctly does NOT report a race when access is properly synchronized.
    // Confirms cases 1 and 2 fail due to the lack of synchronization, not due
    // to a framework false positive.
    @TestCase
    func testSynchronizedDataIsLinearizable(): Unit {
        let result = scenario("demo_data_synced_linearizable")
            .withState { => SyncedData() }
            .consistencyModel(Linearizability)
            .actorWithOps([
                operation("clear")    { s => s.clear() },
                operation("add_0")    { s => s.add("网络数据-0") },
                operation("add_1")    { s => s.add("网络数据-1") },
                operation("add_2")    { s => s.add("网络数据-2") },
                operation("add_3")    { s => s.add("网络数据-3") },
                operation("add_4")    { s => s.add("网络数据-4") },
                operation("add_5")    { s => s.add("网络数据-5") },
                operation("add_6")    { s => s.add("网络数据-6") },
                operation("add_7")    { s => s.add("网络数据-7") },
            ])
            .actorWithOps([
                operation("remove_0") { s => s.remove("网络数据-0") },
                operation("remove_2") { s => s.remove("网络数据-2") },
                operation("remove_4") { s => s.remove("网络数据-4") },
                operation("remove_6") { s => s.remove("网络数据-6") },
            ])
            .iterations(200)
            .build()
            .run()

        println(result.report())
        @Assert(result.passed)
    }
}
