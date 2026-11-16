// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// TIMEOUT: 30
// EXEC: %compiler %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output 400000 | compare %f
// ASSERT: scan deaths: fin=0 loc=0 (expected 0 = never fires)

// M-23 最小复现件：模态区域 × finalizer 交互超线性成本（SDK bug 候选）
// ====================================================================
// 现象: 模态区域（@local! 出生）内带 ~init 的类做体量 churn，耗时超线性 ≈O(n^2.4)；
//       同体量去掉 ~init（腿 B）或离开模态区域（腿 C）均线性毫秒级。
//       且全程 ~init 零点火（腿 A/C deaths=0）——付出全部成本买不到任何可观测语义。
// 三腿对照（同一 N，单变量隔离）:
//   A  模态区域 + ~init        ← 缺陷面（研磨）
//   B  模态区域  无 ~init      ← 隔离变量: finalizer
//   C  ~local 世界 + ~init     ← 隔离变量: 模态区域
// 用法: minrepro.exe <N>       （裸跑默认 100000）
// 预期输出（modal SDK 1.0.0, N=100000）:
//   legB  ~1ms / legC  ~7ms / legA  ~3800ms（千倍差，单次运行即见）
//   超线性判据: N 翻倍 → legA 耗时约 ×4（100k→200k→400k ≈ 3.8s→15s→60s），
//   腿 B/C 保持毫秒级。终末 finDeaths=0。
// 环境（cjc 1.0.0 cjnative）:
//   export PATH="<modal-sdk>/runtime/lib/windows_x86_64_cjnative:<modal-sdk>/bin:$PATH"
//   export CANGJIE_HOME="<modal-sdk_windows路径>"
//   cjc -Woff=all q47_minrepro.cj -o minrepro.exe && ./minrepro.exe 100000
import std.convert.*
import std.time.*

var mBirths: Int64 = 0
var finDeaths: Int64 = 0
var locDeaths: Int64 = 0

// ── 腿 A/B 类（模态区域出生: 双构造器成对, 唯一差 = ~init 有无）──
class FinNode {
    var next: ?Object
    var id: Int64
    init(this @ ~local, id: Int64) { next = None; this.id = id; mBirths += 1 }
    init(this @ local!, id: Int64) {
        exclave {
            next = None
            this.id = id
            mBirths += 1
        }
    }
    ~init(this @local?) { finDeaths += 1 }
}

class PlainNode {
    var next: ?Object
    var id: Int64
    init(this @ ~local, id: Int64) { next = None; this.id = id; mBirths += 1 }
    init(this @ local!, id: Int64) {
        exclave {
            next = None
            this.id = id
            mBirths += 1
        }
    }
}

// ── 腿 C 类（~local 世界: 单构造器 + ~init, 零模态出生）──
class LocFin {
    var next: ?Object
    var id: Int64
    init(this @ ~local, id: Int64) { next = None; this.id = id; mBirths += 1 }
    ~init(this @ ~local) { locDeaths += 1 }
}

func legA(n: Int64): Int64 {   // 模态区域 + finalizer（缺陷面）
    var i = 0
    while (i < n) {
        let t = FinNode(i) @local!
        i += 1
    }
    return mBirths
}

func legB(n: Int64): Int64 {   // 模态区域, 无 finalizer
    var i = 0
    while (i < n) {
        let t = PlainNode(i) @local!
        i += 1
    }
    return mBirths
}

func legC(n: Int64): Int64 {   // ~local 世界 + finalizer
    var i = 0
    while (i < n) {
        let t = LocFin(i)
        i += 1
    }
    return mBirths
}

func legD(n: Int64): Int64 {
    var i = 0
    while (i < n) {
        { =>
            let t = FinNode(i) @ local!;
            i += 1
        }()
    }
    return mBirths
}

main(argv: Array<String>): Int64 {
    let n = if (argv.size > 0) { Int64.parse(argv[0]) } else { 100000 }
    let t0 = MonoTime.now()
    let b = legB(n)
    let t1 = MonoTime.now()
    println("legB modal  no-fin  N=${n} births=${b} ms=${(t1 - t0).toMilliseconds()}")
    let t2 = MonoTime.now()
    let c = legC(n)
    let t3 = MonoTime.now()
    println("legC ~local fin     N=${n} births=${c} ms=${(t3 - t2).toMilliseconds()}")
    let t4 = MonoTime.now()
    let a = legA(n)
    let t5 = MonoTime.now()
    println("legA modal  fin     N=${n} births=${a} ms=${(t5 - t4).toMilliseconds()}")
    let d = legD(n)
    let t6 = MonoTime.now()
    println("legD modal  fin     N=${n} births=${d} ms=${(t6 - t5).toMilliseconds()}")
    println("deaths: fin=${finDeaths} loc=${locDeaths} (expected 0 = never fires)")
    0
}

