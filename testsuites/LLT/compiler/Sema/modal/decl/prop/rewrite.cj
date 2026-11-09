// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
interface RO<T> {
    prop first: ?T
}

interface LOC<T> <: RO<T> where T <: Copyable {
    prop first: ?T @local?
}

class AL<T> <: RO<T> where T <: Copyable {
    public prop first: ?T {
        get() {
            throw IndexOutOfBoundsException("repro")
        }
    }

    public prop first: ?T @local? {
        get() {
            exclave {
                throw IndexOutOfBoundsException("repro")
            }
        }
    }
}

extend<T> AL<T> <: LOC<T> where T <: Copyable {
}

main(): Int64 {
    0
}
