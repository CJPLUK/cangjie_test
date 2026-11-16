// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: modal mangle 的真实符号编码。
// 用一个同时声明三类 modal 重载的类 + 一个带 modal 参数的顶层函数，锁定
// BaseMangler 的 <type-mode> ::= Q<payload>E / <this-mode> ::= W<payload>E
// 编码在真实链接符号中的形状（L=local!, l=local?，缺省不发射）：
//   1) this-only 重载: touch 的 v / WlEv / WLEv 三个变体符号同时存在；
//   2) mut prop 访问器: get/set 各自的 this-mode 变体，set 额外携带
//      值参数的 <type-mode>（HWlElQlE / HWLElQLE）；
//   3) <init> 的 WLE this-mode（HWLEv）；
//   4) 顶层函数参数表内的 <type-mode> 串（HlQlElQLE）。
// 符号串与 demangler 单测（unittests/Demangle）互为镜像：mangler 变更破坏
// ABI 时本用例先红。不设精确计数（define/declare/call 组合随内联变化），
// 只锁符号存在性。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan _CN7default3Box5touchHv
// ASSERT: scan _CN7default3Box5touchHWlEv
// ASSERT: scan _CN7default3Box5touchHWLEv
// ASSERT: scan _CN7default3Box2pApgHv
// ASSERT: scan _CN7default3Box2pApgHWlEv
// ASSERT: scan _CN7default3Box2pApgHWLEv
// ASSERT: scan _CN7default3Box2pApsHl
// ASSERT: scan _CN7default3Box2pApsHWlElQlE
// ASSERT: scan _CN7default3Box2pApsHWLElQLE
// ASSERT: scan _CN7default3Box6<init>HWLEv
// ASSERT: scan _CN7default14withLocalParamHlQlElQLE

class Box {
    var n: Int64 = 0
    init(this @~local) {}
    exclave init(this @local!) {}

    // modal-overloaded props: same data type, different modes
    mut prop pA: Int64 @~local {
        get() { n }
        set(v) { n = v }
    }
    mut prop pA: Int64 @local? {
        get() { n + 1 }
        set(v) { n = v }
    }
    mut prop pA: Int64 @local! {
        get() { n + 2 }
        set(v) { n = v }
    }

    // this-mode-only overloads (no explicit params)
    func touch(this @~local): Int64 { 1 }
    func touch(this @local?): Int64 { 2 }
    func touch(this @local!): Int64 { 3 }
}

func withLocalParam(a: Int64 @local?, b: Int64 @local!): Int64 {
    return a + b
}

main(): Int64 {
    let b0: Box @~local = Box()
    let b2: Box @local! = Box() @local!
    b0.pA = 7
    println("touch=${b0.touch()} ${b2.touch()}")
    let localQ: Int64 @local? = 40
    let localF: Int64 @local! = 2
    println("sum=${withLocalParam(localQ, localF)} pA=${b0.pA} pA2=${b2.pA}")
    return 0
}
