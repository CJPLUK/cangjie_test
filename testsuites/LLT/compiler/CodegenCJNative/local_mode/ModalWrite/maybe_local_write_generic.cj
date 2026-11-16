// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 泛型（未实例化）字段在 CodeGen 里走 size-less 分支：先运行期判定 IsReference，
// 再分流成 gcwrite_ref / gcwrite_non_ref 两个基本块。其中 gcwrite_ref 是真正的引用写入，
// 同样必须使用 maybeLocalWrite 屏障，否则 local? 对象的泛型引用字段会静默退回普通屏障、
// 丢掉 local root 登记。这条用例锁定该分支不被遗漏。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-2 llvm.cj.maybe.local.write.ref

class D {
    var tag = 0
    init() {}
}

class Box<T> {
    var v: T
    init(this @local?, x: T) {
        exclave {
            this.v = x
        }
    }
}

main(): Unit {
    var b: Box<D> @local? = Box<D>(D()) @local?
    println(b.v.tag)
}
