// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class D {
    var id: Int64
    init(i: Int64) { id = i }
    init(this @local!, i: Int64) { exclave { id = i } }
    init(this @local?, i: Int64) { exclave { id = i } }
}

class Box<T> {
    demode var value: T
    init(v: T) { value = v }
    init(this @local!, v: T) { exclave { value = v } }
    init(this @local?, v: T) { exclave { value = v } }
}

class Pair<T, U> {
    demode var first: T
    demode var second: U
    init(a: T, b: U) {
        first = a
        second = b
    }
    init(this @local!, a: T, b: U) {
        exclave {
            first = a
            second = b
        }
    }
    init(this @local?, a: T, b: U) {
        exclave {
            first = a
            second = b
        }
    }
}

func innerD(outer: Box<Box<D>> @local?): D @local? {
    exclave {
        outer.value.value
    }
}

func firstOf(p: Pair<D, D> @local?): D @local? {
    exclave {
        p.first
    }
}

func secondOf(p: Pair<D, D> @local?): D @local? {
    exclave {
        p.second
    }
}

main(): Int64 {
    let d: D = D(42)
    let inner: Box<D> = Box<D>(d)
    let outer: Box<Box<D>> @local? = Box<Box<D>>(inner)
    let r: D @local? = innerD(outer)

    let d2: D = D(100)
    let pair: Pair<D, D> @local? = Pair<D, D>(d, d2)
    let rd1: D @local? = firstOf(pair)
    let rd2: D @local? = secondOf(pair)

    let _: D @local? = r
    let _: D @local? = rd1
    let _: D @local? = rd2
    0
}
