// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

class C {
    exclave init(this @local!) {}
}
func foo(): C@local! {
    exclave {
        C()
    }
    exclave {
        C()
    }
}

func bar(): C@local! {
    exclave {
        C()
    }
    exclave { foo() } // unreachable here
}
main() {
    foo()
    0
}