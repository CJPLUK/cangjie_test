// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class C {
    init() {}
    init(this @local!) { exclave { } }
}

func boxInternalToAnyHalf(c: C @local!) {
    let a: Any @local? = c
}

func boxHalfToAnyHalf() {
    let c: C @local? = C()@local!
    let a: Any @local? = c
}

func boxExternalToAnyHalf() {
    let c: C @~local = C()
    let a: Any @local? = c
}

main(): Int64 {
    boxInternalToAnyHalf(C()@local!)
    boxHalfToAnyHalf()
    boxExternalToAnyHalf()
    0
}
