// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package objc.sample.macros

import std.ast.*
import std.convert.*
import std.time.*

const N = 2000000

public macro Test(arg: Tokens, input: Tokens) {
    let arg0 = arg[0]
    let arg1 = arg[arg.size - 1]

    let processedInput = Tokens()
    for (it in input) {
        if (it.value == "$N") {
            processedInput.append(arg0)
        } else {
            processedInput.append(it)
        }
    }

    return quote(
        const N = $(N)
        const name = $(arg1)
        const iters = $(arg0)
        let ITER = 5
        var sum = 0
        for (j in 0..ITER) {
            let t0 = DateTime.now()
            var x = 0
            for (_ in 0..N) {
                unsafe {
                    x += $processedInput
                }
            }
            let t1 = DateTime.now()
            let ns = (t1 - t0).toNanoseconds()
            if (j == 0) {
                print ("${x.format("20")} ${name} Iter=${iters.format("3")} time ${(ns / 1000000).format("5")} ms; per call:")
            }
            print (" ${(ns / N).format("4")}")
            sum += ns
        } 
        println ("  AVG ${(sum / ITER / N).format("4")} ns");
    )

}
