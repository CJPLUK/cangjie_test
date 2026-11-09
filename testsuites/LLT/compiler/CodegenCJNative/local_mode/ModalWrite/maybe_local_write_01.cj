// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 在 init(this @local?) 中对 this 的引用型实例成员赋值时，编译器无法静态判定右值
// 分配在 local region 还是 heap，该写入必须被标记为 maybeLocalWrite，
// 后端据此发射 CJ_MCC_MaybeLocalWriteRef 以便运行时登记 local root。

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC-PIPE: %cat tmps/%n.ll 2>&1 | compare %f
// ASSERT: scan-2 llvm.cj.maybe.local.write.ref

class T {
    var v = 0
    init(this @~local) {}
}

class C {
    var x: T
    init(this @local?, p: T @local?) {
        exclave {
            this.x = p
        }
    }
}

main() {
    let th = T()
    var c1: C @local? = C(th) @local?
    return 0
}
