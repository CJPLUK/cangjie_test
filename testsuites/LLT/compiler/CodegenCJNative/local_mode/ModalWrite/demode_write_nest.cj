// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// demode 字段的类型恒为 @~local，写入的新值一定在 heap 上；而持有者是 @local!，
// 位于 local region。这显式构成 region -> heap，必须标记为 demodeWrite，
// 后端据此发射 CJ_MCC_DemodeWriteRef。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-3 llvm.cj.demode.write.ref


public class D {
    public var tag = 0
    public init() {}
    public init(this @local!) { exclave {} }
}

public class Inner {
    demode public var data: D
    public init() { data = D() }
    public init(this @local!) { exclave { data = D() } }
}

public class Outer {
    demode public var inner: Inner
    public init() { inner = Inner() }
    public init(this @local!) { exclave { inner = Inner() } }
}

func nestedAccess(): Unit {
    var outer: Outer @local! = Outer() @local!
    outer.inner.data = D() @~local
    println(outer.inner.data.tag)
}

main(): Unit {
    nestedAccess()
}
