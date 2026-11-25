// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 带 class 引用 payload 的 enum 构造（GenerateCommonEnum）的分配区域
// 选择与 payload 槽写屏障分类。
// 1. `E @local!` 的 enum 构造必须走 local 区分配器（llvm.cj.malloc.local.object）。
// 2. payload 写必须走 llvm.cj.maybe.local.write.ref：类型系统要求 `E @local!` 的
// payload 为 `C @local!`，故代码中 payload 恒为 local；若 payload 分类退回普通 gcwrite.ref，
// 未来 payload 侧放开 heap 混入时边将不被登记，GC后 payload 悬垂。
// 断言（按调用点分解）：
//   1) malloc.local.object 共 10 处（声明 1 + 调用 9：ctor/poke 各 C+E+C+E
//      四次构造、main 一次 K 构造；churn 的 Array 走堆分配）；
//   2) maybe.local.write.ref 共 5 处（声明 1 + 调用 4：ctor/poke 各两次
//      enum payload 写）；
//   3) call void @llvm.cj.gcwrite.ref 共 6 处（ctor/poke 各两次 `E @local!`
//      字段写为 local->local 普通快路径 + churn 数组内部两处）；
//   4) 全程不出现 demode.write.ref；
//   5) 端到端结果正确（GC 后经 enum payload 读回 7）。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-10 llvm.cj.malloc.local.object
// ASSERT: scan-5 llvm.cj.maybe.local.write.ref
// ASSERT: scan-6 call void @llvm.cj.gcwrite.ref
// ASSERT: scan-not llvm.cj.demode.write.ref

class C {
    var v: Int64
    init(this) { v = 0 }
    exclave init(this @ local!) { v = 7 }
}
enum E { A(C) | B(C) }
class K {
    var e: E
    var h: E
    exclave init(this @ local!) {
        e = E.A(C() @local!)
        h = E.A(C())
    }
    func poke(this @ local!): Unit {
        exclave {
            e = E.A(C() @local!)
            h = E.A(C())
            churn(50000)
            match (e) {
                case A(c) => println("A ${c.v}")
                case B(c) => println("B ${c.v}")
            }
            match (h) {
                case A(c) => println("H ${c.v}")
                case B(c) => println("H ${c.v}")
            }
        }
    }
}
func churn(n: Int64): Unit {
    var i: Int64 = 0
    while (i < n) {
        let a = Array<Int64>(256, {j => j})
        i = i + 1
    }
}
main(): Int64 {
    let k = K() @local!
    k.poke()
    if (true) {
        println("GOOD")
        return 0
    }
    return 1
}
