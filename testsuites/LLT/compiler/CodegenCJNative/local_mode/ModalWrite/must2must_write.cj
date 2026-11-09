// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: ClassifyModalWrite 的 MUST2MUST 快路径 (ModalWrite.cpp)。
// 当 this 与成员写入双方的 modal 均为 MUST（local! -> local!）且非泛型时，
// 写屏障分类必须落到 NONE，直接退回普通 gcwrite.ref 屏障；若该快路径失效，
// local! 对象的引用字段写入会退化为 maybe.local.write.ref（每次写入多一次
// local root 登记，性能回归），因此这里同时断言：
//   1) 两个 <init>（heap 版与 local! 版）各产生 1 处普通 gcwrite.ref，共 2 处；
//   2) 全程不出现任何 maybe.local.write.* 屏障；
//   3) 端到端结果正确（c1/c2 两条链各写回 42）。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-2 call void @llvm.cj.gcwrite.ref
// ASSERT: scan-not llvm.cj.maybe.local.write

class T {
    var v = 0
    init(this @~local) {}
    exclave init(this @local!) {}
}

class C {
    var x: T
    init(this @~local, p: T @~local) {
        this.x = p
    }
    exclave init(this @local!, p: T @local!) {
        this.x = p
    }
}

main(): Int64 {
    let t1: T @local! = T() @local!
    var c1: C @local! = C(t1) @local!
    c1.x.v = 42

    let t2: T = T() @~local
    var c2: C = C(t2) @~local
    c2.x.v = 42

    if (c1.x.v != 42 || c2.x.v != 42) {
        return 1
    } else {
        return 0
    }
}
