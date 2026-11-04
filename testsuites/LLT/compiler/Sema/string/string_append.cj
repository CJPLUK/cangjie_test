// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan-begin true
// ASSERT: scan-next abcdabcd
// ASSERT: scan-end

func foo() {
    let builder = StringBuilder(64)
    let text: String @local! = "abcd"

    builder.append(text)
    builder.append(text)

    println(builder.toString() == "abcdabcd")
    println(builder.toString())
    0
}

main() {
    foo()
    0
}
