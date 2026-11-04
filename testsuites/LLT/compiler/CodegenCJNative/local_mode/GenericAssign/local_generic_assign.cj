// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 泛型 T @local! 的局部变量复用必须走 generic local 屏障链路。
// pick<T> 的形参/返回值均为 T @local!（未实例化泛型），函数体内局部变量 r 的
// 初始化与 if/else 汇合后的 phi 写回无法静态判定布局，CodeGen 依次发射：
//   1) llvm.cj.alloca.local.generic  x2 —— 泛型局部槽的局部分配（a/b -> r 两路）；
//   2) llvm.cj.assign.local.generic  x3 —— 泛型值向局部槽的赋值（含返回值写回）；
// 若 assign/alloca 的 local 变体被遗漏（退回普通 assign.generic / alloca.generic），
// 泛型局部槽会被当作普通堆槽，local root 登记丢失，GC 后悬挂。
// 该形状与 local region 的判定无关（形参本身 @local!），单独成例防回归。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-2 call i8 addrspace(1)* @llvm.cj.alloca.local.generic
// ASSERT: scan-3 call void @llvm.cj.assign.local.generic

class D {
    var v: Int64
    init(this @~local, x: Int64) { v = x }
    exclave init(this @local!, x: Int64) { v = x }
}

exclave func pick<T>(flag: Bool, a: T @local!, b: T @local!): T @local! {
    let r: T @local! = if (flag) { a } else { b }
    return r
}

main(): Int64 {
    let a: D @local! = D(5) @local!
    let b: D @local! = D(6) @local!

    let r: D @local! = pick<D>(true, a, b)
    let r2: D @local! = pick<D>(false, a, b)

    println("r=${r.v} r2=${r2.v}")
    return if (r.v == 5 && r2.v == 6) { 0 } else { 1 }
}
