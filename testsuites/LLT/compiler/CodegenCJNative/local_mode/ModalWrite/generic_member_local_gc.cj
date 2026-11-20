// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 泛型成员写（字段类型为带 modal 的泛型 `T @local!`）的写屏障分类
// （ModalWrite.cpp dispatchedOnRuntimeRefness 规则）。
// 字段类型 `T @local!` 的布局在编译期不可知（unsized），CodeGen 通过
// EmitOpaqueFieldWriteBarrier 在运行期按实际 TypeInfo 分派：引用形态走
// llvm.cj.maybe.local.write.ref，值形态走 llvm.cj.maybe.local.write.generic。
// 若分类错误地退回普通 gcwrite.generic（其运行时入口拒绝 local 对象）或
// demode.write.ref（对 local 值直接 FATAL/错误登记），GC 翻搅后经泛型字段
// 读回的对象将被破坏。同时裸 `T`（无 modal）成员写被类型系统拒绝
// （bare 类型只允许 heap 值），不在此看护范围内。
// 断言：
//   1) exclave 构造与 set 方法两处 `T @local!` 成员写各产生 ref/generic 两个
//      运行期分派分支，即 maybe.local.write.ref / maybe.local.write.generic
//      各 2 次调用 + 1 条声明；
//   2) 全程不出现普通 gcwrite.ref 与 demode.write.ref；
//   3) 端到端结果正确（GC 翻搅后读回 43）。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-3 llvm.cj.maybe.local.write.ref
// ASSERT: scan-3 llvm.cj.maybe.local.write.generic
// ASSERT: scan-not call void @llvm.cj.gcwrite.ref
// ASSERT: scan-not llvm.cj.demode.write.ref

class Box {
    var v: Int64
    init(this @ ~local, x: Int64) { v = x }
    exclave init(this @ local!, x: Int64) { v = x }
}

class Holder<T> {
    var x: T
    exclave init(this @ local!, v: T @local!) { x = v }
    func set(this @ local!, v: T @local!): T @local! { x = v; return v }
}

class Junk {
    var a: Int64 = 119304647
    init(this @ ~local) {}
}

main(): Int64 {
    let b = Box(42) @ local!
    let h = Holder<Box>(b) @ local!
    let b2 = Box(43) @ local!
    h.set(b2)
    var acc: Int64 = 0
    var i: Int64 = 0
    while (i < 2000000) {
        let j = Junk() @ ~local
        acc += j.a
        if (acc > 100000000) { acc = 0 }
        i += 1
    }
    let got = h.x.v
    println("got=${got}")
    if (got == 43) {
        println("GOOD")
        return 0
    }
    println("BAD")
    return 1
}
