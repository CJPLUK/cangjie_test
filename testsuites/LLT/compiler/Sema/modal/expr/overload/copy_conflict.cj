// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

struct F <: Copyable {}

func foo(a: F@local!, b: Int) {}
func foo(a: F@local?, b: Int @local!) {}

open class C {
    func foo(a: F@local!, b: Int) {}
}

class D <: C {
    func foo(a: F, b: Int@local!) {}
}

main() {}
