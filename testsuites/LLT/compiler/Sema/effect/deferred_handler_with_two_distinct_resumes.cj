// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %enableEH %cmp_opt %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output 2>&1 | compare %f

import stdx.effect.{Command, Resumption}

class CmdA <: Command<Int64> {}
class CmdB <: Command<Bool> {}

main() {
    let saved : Box<Option<Resumption<Int64, Int64>>> = Box(None)

    // Frame A: store resumption
    let r1 = try {
        perform CmdA()
        println("got here 2")
        0
    } handle (_: CmdA, r: Resumption<Int64, Int64>) {
        saved.value = Some(r)
        0
    }

    println("got here 0")

    // Frame B: resume the stored resumption from within the handler
    let r2 = try {
        perform CmdB()
        println("got here 4")
        0
    } handle (_: CmdB, r_: Resumption<Bool, Int64>) {
        // Resume stored resumption from Frame A
        // This triggers CJ_MRT_ThreadReady(handleeA) inside
        println("got here 1")
        let v = resume saved.value.getOrThrow() with 42
        println("got here 3")
        // Then resume Frame B's own resumption
        resume r_ with true
        println("got here 5")
        0
    }

    println("r1=${r1}, r2=${r2}")
}

/* SCAN
got here 0
got here 1
got here 2
got here 3
got here 4
got here 5
r1=0, r2=0
*/