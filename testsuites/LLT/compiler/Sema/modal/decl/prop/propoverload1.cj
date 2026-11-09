// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
interface I {
    prop size: Int @local? {
        get() {1}
    }
}
class C <: I {
    init() {}
    exclave init(this @local!) {}
    public prop size: Int {
        get() {3}
    }
}

main() {
    let c:I @local! = C() @local!
    c.size-1
}
