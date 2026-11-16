// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all

func foo<T>(x: T @local!)  {
    @local? func goo1(y: T @local!): Unit {
        exclave {
            @local? func goo2(z: T @local!): Unit {
                exclave {
                }
            }
            goo2(y)
        }
    }
    exclave {
        goo1(x)
    }
}

main() {
}