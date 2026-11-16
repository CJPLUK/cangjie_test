// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 嵌套 demode：o 是 @local!，但 inner 被 demode 修饰，因此 o.inner 的类型是 Inner @~local，
// 位于 heap。于是 o.inner.data 的**直接持有者**在 heap 上，写入构成 heap -> heap，不应被标记。
//
// 这条用例锁定的是：判定必须沿字段路径走到最后一级的直接持有者，
// 而不是简单地看根对象 o 的 mode——否则会误判为 region -> heap 而多发一次屏障。

// LEVEL: 0
// DEPENDENCE: pkgA
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableAPC %compile_lib_opt pkgA/pkgA.cj -o pkgA.%middle
// EXEC: %compiler %local %cmp_opt %disableAPC %save_temps_opt=tmps pkgA.%middle %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-not llvm.cj.maybe.local.write.ref
// ASSERT: scan-not llvm.cj.demode.write.ref

import pkgA.*

func nestedAccess(): Unit {
    var outer: Outer @local! = Outer() @local!
    outer.inner.data = D() @~local
    println(outer.inner.data.tag)
}

main(): Unit {
    nestedAccess()
}
