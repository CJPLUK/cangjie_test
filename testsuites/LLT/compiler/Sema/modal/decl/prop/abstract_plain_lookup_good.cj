// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface R {
    prop first: Int64
    prop first: Int64 @local? {
        get() {
            throw UnimplementedException("local? first")
        }
    }
}

class B <: R {
    public prop first: Int64 {
        get() {
            7
        }
    }
}

main(): Int64 {
    let b: R = B()
    0
}
