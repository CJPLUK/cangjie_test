// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

open class A<T> {

}

class B<T> <: A<T> {

}

func foo<T>(a: A<T>) {}
func foo<T>(a: B<T>) {}

main() {
    let a: B<Int64> = B<Int64>()
    foo(a)
}