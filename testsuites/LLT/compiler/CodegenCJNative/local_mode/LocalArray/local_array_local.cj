// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 局部区域内的数组分配必须走 local 数组路径 (llvm.cj.malloc.local.array)。
// 1) local region 中构造 Array<D> 字面量时，数组本体分配给到
//    llvm.cj.malloc.local.array。这里锁定 main 中长度为 2 的字面量；编译器
//    额外实例化的 std.modal Array<D> 构造函数数量不属于本用例的看护目标；
// 2) 若该路径被误并入普通 heap 数组分配（如 NewArrayFast 内联快路径），
//    local 数组会落入普通堆 TLR 缓冲，local root 登记表在 GC 回收后悬挂，
//    并发标记阶段解引用被覆写内存直接崩溃 —— 该错误只能靠端到端在 GC 压力下
//    暴露，这里锁定分配路径本身不被静默替换；
// 3) 数组元素读写经 std.modal ix 重载（local! this），结果端到端一致。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.opt.bc
// EXEC-PIPE: %cat tmps/%n.opt.ll 2>&1 | compare %f
// ASSERT: regex @CJ_MCC_NewLocalObjArray,.*RawArray<default:D>.*i64 2,
// ASSERT: regex-not @CJ_MCC_NewObjArray,.*RawArray<default:D>.*i64 2,

class D {
    var tag: Int64
    init(this @~local, t: Int64) { tag = t }
    exclave init(this @local!, t: Int64) { tag = t }
}

main(): Int64 {
    let a: D @local! = D(1) @local!
    let b: D @local! = D(2) @local!

    // local array of class refs: array itself and elements are local!
    var arr: Array<D> @local! = [a, b]
    arr[0] = D(3) @local!
    let s = arr[0].tag + arr[1].tag

    println("local array sum = ${s}")
    return if (s == 5) { 0 } else { 1 }
}
