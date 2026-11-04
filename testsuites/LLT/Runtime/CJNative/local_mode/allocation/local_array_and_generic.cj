// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Cover reference arrays, value arrays, VArray and generic local objects.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan arrays: 18
// ASSERT: scan generic: 17

import std.runtime.*

class Item {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

class Box<T> {
    var value: T

    exclave init(this @local?, value: T) {
        this.value = value
    }
}

func makeValueArray(): Array<Int64> @local? {
    exclave { [2, 4, 6, 8] }
}

func makeRefArray(): Array<Item> @local? {
    exclave { [Item(3), Item(5)] }
}

func makeVArray(): VArray<Int64, $3> @local! {
    VArray<Int64, $3> { i => i + 1 }
}

main(): Unit {
    let values = makeValueArray()
    let refs = makeRefArray()
    let fixed = makeVArray()
    gc()
    gc()
    let sum = values[0] + values[3] + refs.size + fixed[0] + fixed[1] + fixed[2]
    println("arrays: ${sum}")

    let box: Box<Item> @local? = Box<Item>(Item(17)) @local?
    gc()
    gc()
    println("generic: ${box.value.value}")
}
