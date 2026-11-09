// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {}
struct A<T> {}

type MM = C

func foo() {
    let a = C() @~local
    let b = MM() @~local
    let e: Int32 @local! = Int32(8)
    let f: UInt8 @local! = UInt8(e)
    let g: Int64 @local? = Int64(f)
    let h: Float32 @~local = Float32(g)
}
main() {}
