// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

func foo(a: Int @local!): String @local? {
    exclave {
        "haha"
        "hello"
    }
}

class T {
    func bar(a: String @local!): Int {
        if (a.size < 3) {
            return exclave {
                a.size
            }
        }
        exclave {
            a.size + 1
        }
    }
}
main() {}