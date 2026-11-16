// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: GenerateNativeTuple 局部区域内构造带泛型参数的元组 (K, Int64) @local!:
// 元组经 llvm.cj.alloca.local.generic 分配(局部对象), 其泛型布局元素的写入必须
// 使用 llvm.cj.maybe.local.write.generic;


// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-1 call void @llvm.cj.maybe.local.write.ref
// ASSERT: scan-1 call void @llvm.cj.maybe.local.write.generic

exclave func g2mk<K>(a: K @local!): (K, Int64) @local! {
    let t = (a, 42)
    return t
}

main(): Int64 {
    let s: String @local! = "guard2"
    let t = g2mk<String>(s)
    println("guard2 ok ${t[1]}")
    0
}
