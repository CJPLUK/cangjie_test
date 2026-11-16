// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A zero-sized (Unit-typed) static variable occupies no storage at all. When
// it happens to be the last .bss fragment after linking, its symbol address
// equals the end of the output section, so no section covers it and the
// debugger fails to inspect it with "read memory failed".

// EXEC: %compiler %cmp_opt -g --apc=5 %n.cj -o %n.%suffix
// EXEC: %run %run_opt %n.%suffix
// (DEBUG_OPTION)EXEC: %frontendCompiler %dump-ir-to-screen %cmp_opt %enableCompileDebug --apc=5 %n.cj 2>&1 | compare %f
// ASSERT: regex-1 @_CN7default1A1uE = global %Unit.Type zeroinitializer, align 8, !dbg
// ASSERT: regex-auto @.cjzsguard = internal global i8 0

public class A {
    public static var u: Unit = ()
    public static var x: Int64 = 42
}

main() {
    let t = A.x + 1
    println("${t}")
    0
}
