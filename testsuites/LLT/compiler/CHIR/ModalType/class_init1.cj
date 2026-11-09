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

class A {
    var a = 1
    init(this @local!) {
        exclave {
            a = 2
        }
    }
    init(this @~local) {
        a = 3
    }
}

main() {
    var a: A @local! = A()
    var b: A = A()
    if (a.a == 2 && b.a == 3) {
        return 0
    }
    return 1
}