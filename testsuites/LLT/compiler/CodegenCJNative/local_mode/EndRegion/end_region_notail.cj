// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 看护：cjc 生成 CJ_MCC_EndLocalRegion 调用时必须标记 notail。
//
// local region 的 owner 信息取自"调用者"栈帧，若 EndLocalRegion 被尾调用化，
// 进入桩函数前当前帧已弹出，桩会以调用者的帧指针关闭错误（上层）的 region，
// 导致上层 local 对象提前失去 region 保护。cjc 侧在 HandleEndRegion 中通过
// setTailCallKind(TCK_NoTail) 阻止尾调用化；本用例在后端 LLVM IR 层面断言
// 每个 CJ_MCC_EndLocalRegion 调用都带有 notail 标记。
//
// O2 下 TCE 与 notail 的配合行为由 llvm-project TailCallElim/notail.ll 看护；
// O2 端到端运行时行为由 end_region_notail_o2.cj 看护。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan notail call void @CJ_MCC_EndLocalRegion
// ASSERT: regex-not (?<!notail )call void @CJ_MCC_EndLocalRegion

class Box {
    var v: Int64
    init(this @~local, x: Int64) { v = x }
    exclave init(this @local!, x: Int64) { v = x }
}

var sink: Int64 = 0

// 函数体先开 local region（String 字面量与 Box 均分配在 local region），
// 返回前关闭 region，即产生 CJ_MCC_EndLocalRegion 调用。
func inner(x: Int64): Unit {
    let s: String @local! = "region-end-notail"
    let b: Box @local! = Box(x)
    sink = b.v + s.size
}

main(): Int64 {
    inner(5)
    println("notail ok: ${sink}")
    return 0
}
