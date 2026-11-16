// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
class C {
    var v: Int64
    init(x: Int64) { v = x }
}
func f(): C @local? {
    let w: C @ ~local = C(1)
    return w
}
main(): Int64 {
    let _ = f()
    return 0
}
