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

var globalBox: Box<D> = Box<D>(D(1))

func readLocked(b: Box<D> @local!): D @~local {
    b.value
}

func writeLocked(b: Box<D> @local!, v: D @~local) {
    b.value = v
}

func readLockedHalf(b: Box<D> @local?): D @~local {
    b.value
}

func readNestedLocked(outer: Box<Box<D>> @local!): D @~local {
    let inner: Box<D> @~local = outer.value
    inner.value
}

main(): Int64 {
    let d: D = D(42)
    let b: Box<D> @local! = Box<D>(d)
    let r1: D @~local = readLocked(b)
    writeLocked(b, d)

    let d2: D = D(7)
    let bh: Box<D> @local? = Box<D>(d2)
    let r2: D @~local = readLockedHalf(bh)

    let din: D = D(99)
    let bin: Box<D> = Box<D>(din)
    let outer: Box<Box<D>> @local! = Box<Box<D>>(bin)
    let r3: D @~local = readNestedLocked(outer)

    let g: D @~local = globalBox.value
    let sum: Int64 = r1.id + r2.id + r3.id + g.id
    let _: Int64 = sum
    0
}
