// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

class C<T> {
    init() {}
    init(this @local?) {
        exclave {}
    }
}

class D {
    init() {}
    init(this @local?) {
        exclave {}
    }
}

type F = D 

func foo(value: Array<Byte> @local?, st!: Bool = true) {

}

main() {
    let a: Array<Byte> @local? = []
    foo(a)
}