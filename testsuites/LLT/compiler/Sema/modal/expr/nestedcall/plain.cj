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
    func read(_: A): Int64 {
        1
    }
    func read(_: A @local!): Int64 {
        2
    }
}

class Inner {
    init() {}
    exclave init(this @local!) {}
}

class Outer {
    init(_: Inner) {}
    exclave init(this @local!, _: Inner @local!) {}
}

struct SA {
    init() {}
    exclave init(this @local!) {}
}

struct SFile {
    func read(_: SA): Int64 {
        1
    }
    func read(_: SA @local!): Int64 {
        2
    }
}

main() {
    let f = File()
    println(f.read(A()))
    let _o = Outer(Inner())
    let sf = SFile()
    println(sf.read(SA()))
}

/* SCAN
1
1
*/
