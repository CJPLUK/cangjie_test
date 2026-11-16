// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args
public interface InputStream {
    func read(_: Array<Byte>): Int64 {
        0
    }
    func read(_: Array<Byte> @local!): Int64 {
        1
    }
}
class M <: InputStream {}
func foo(a: InputStream): Int64 {
    a.read([1,2,3])
}
main() {
    foo(M())
}
