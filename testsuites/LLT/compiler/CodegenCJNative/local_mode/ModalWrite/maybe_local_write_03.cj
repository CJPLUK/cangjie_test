// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 负向用例：Copyable 字段（Int64）不含引用，不可能跨越 region/heap 边界，不应被标记。
// 同时 init(this @local!) 的持有者与右值都确定在 region 中（region -> region），也不需要屏障。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %run %run_opt %output %run_args && %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan a.n + b.n = 3
// ASSERT: scan-not llvm.cj.maybe.local.write.ref

class C {
    var n: Int64
    init(this @local!, v: Int64) {
        exclave {
            this.n = v
        }
    }
    init(this @~local, v: Int64) {
        this.n = v
    }
}

main(): Unit {
    var a: C @local! = C(1) @local!
    var b: C = C(2) @~local
    println("a.n + b.n = ${a.n + b.n}")
}
