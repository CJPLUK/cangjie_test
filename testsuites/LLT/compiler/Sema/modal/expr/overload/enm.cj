// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

func foo(): ?String @local! {
    exclave { Option<String>.None}
}

class B<T> {
    let value: T 

    init(v: T) {
        value = v
    }
    init(this @local!, v: T @local!) {
        exclave { value = v }
    }
}

class C<T> {
    init(a: T @local!) {
        exclave {
            var v: Option<T> @local! = Option<T>.Some(a)@local!
            var v2: Option<T> @local! = Option<T>.Some(a)
        }
    }
}
main() {
    let a: Option<Int64> @local! = Option<Int64>.Some(1)
    let b: Option<Int64> @local! = Option<Int64>.Some(1)@local!
}