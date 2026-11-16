// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
func foo(_: CFunc<()->Int>) {
    0
}
func foo(_: CFunc<()->Int> @local!) {
    1
}

@C foreign func rand(): Int
main() {
    foo(rand)
}