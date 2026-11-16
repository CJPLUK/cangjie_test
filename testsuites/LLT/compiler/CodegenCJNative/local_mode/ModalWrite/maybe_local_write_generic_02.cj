// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: ClassifyModalWrite 泛型结构体 exclave init 内对泛型参数类型成员赋值:
// owner 与 member 均为 local! 且 member 是泛型时不得走捷径, 必须返回 MAYBE_LOCAL,

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-1 call void @llvm.cj.maybe.local.write.ref
// ASSERT: scan-1 call void @llvm.cj.maybe.local.write.generic

struct G1<K> {
    let k: K
    exclave init(this @local!) { k = unsafe { zeroValue2<K>() } }
}

main(): Int64 {
    let a: G1<String> @local! = G1<String>() @local!
    let b: G1<Int64> @local! = G1<Int64>() @local!
    println("guard1 ok")
    0
}
