// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %n.cj -o %output
// EXEC-PIPE-0: %run %output
// EXEC: %compiler %local %n.cj %enableO2 -o %output
// EXEC-PIPE-0: %run %output

func foo(x: Int64 @local!): Int64 @local? {
    x + 10
}

func goo(x: Int64 @local!): Int64 @local? {
    x + 100
}

main() {
    var x = foo
    x = goo
    if (x(10) == 110) {
        return 0
    }
    return 1
}