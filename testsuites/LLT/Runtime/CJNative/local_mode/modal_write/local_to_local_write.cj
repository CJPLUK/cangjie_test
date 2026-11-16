// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A local owner storing a local value must not hit the ordinary heap barrier.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local to local: 29

class Leaf {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

class Holder {
    var child: Leaf

    exclave init(this @local!, child: Leaf @local!) {
        this.child = child
    }
}

main(): Unit {
    let leaf: Leaf @local! = Leaf(29) @local!
    let holder: Holder @local! = Holder(leaf) @local!
    println("local to local: ${holder.child.value}")
}
