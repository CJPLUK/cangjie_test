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

class File {
    func read(x!: A, y!: Int64 = 0): Int64 {
        1
    }
    func read(x!: A @local!, y!: Int64 = 0): Int64 {
        2
    }
}

func take(x!: A, y!: Int64 = 1): Int64 {
    1
}
func take(x!: A @local!, y!: Int64 = 1): Int64 {
    2
}

main() {
    let f = File()
    println(f.read(x: A()))
    println(take(x: A()))
}

/* SCAN
1
1
*/
