// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output 2>&1
// RUN-EXEC: %run %run_opt %output %run_args


func foo(): String @local! {
    exclave { "x" }
}
exclave func bar(): String @local? {
    "x"
}

func baz(): Unit @local? {
    ()
}
func but(): Unit @local! {
    ()
}

main() {}