// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 负向用例：init(this @~local) 构造的对象一定在 heap 上，写引用字段是 heap -> heap，
// 走既有的普通 GC 写屏障即可，不应被标记。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-not llvm.cj.maybe.local.write.ref

class T {
    var v = 0
    init(this @~local) {}
}

class C {
    var x: T
    init(this @~local, p: T @~local) {
        this.x = p
    }
}

main(): Unit {
    let th = T()
    var c2: C = C(th) @~local
}
