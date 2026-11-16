// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output -Woff all
// EXEC: %run %run_opt %output %run_args | compare %f

class A {
    init() {}
    exclave init(this @local!) {}
}

func take(x: ?A): Int64 {
    1
}
func take(x: ?A @local!): Int64 {
    2
}

main() {
    println(take(Option<A>.Some(A())))
}

/* SCAN
1
*/
