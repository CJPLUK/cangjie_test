// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 负向用例：demode 字段的持有者是 @~local，一定在 heap 上，写入构成 heap -> heap，
// 不需要 CJ_MCC_DemodeWriteRef，走普通写屏障即可，因此不应被标记。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-not llvm.cj.demode.write.ref

class D {
    var tag = 0
    init() {}
    init(this @local!) { exclave {} }
}

class Holder {
    demode var payload: D
    init() { payload = D() }
}

main() {
    var y: Holder = Holder()
    return y.payload.tag
}
