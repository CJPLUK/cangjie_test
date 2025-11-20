// EXEC: %compiler %enableEH %cmp_opt %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output
import stdx.effect.{Command, Resumption}

class Eff <: Command<Int64> {}

public func assertPerformed<T>(fn: ()->Int64, msg!: String = ""): Int64 where T <: Command<Int64> {
    try{
        fn()
    } handle (e: T, r: Resumption<Int64, Int64>){
        resume r with 11
    }
}

main():Int64 {
    let a = assertPerformed<Eff>({ => perform Eff() })
    if (a != 11) {
        return 1
    }
    return 0
}



// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
