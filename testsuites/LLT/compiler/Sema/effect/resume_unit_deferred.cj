// EXEC: %compiler %enableEH %cmp_opt %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output %run_args
import stdx.effect.{Command, Resumption}

func foo(r: Resumption<Unit, Unit>) {
    resume r
}

main():Int64 {
    return 0
}


// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
