// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
class Dog {
    exclave init(this @local!) {}
    func roat(this @local!) {4}
}

class TupleIterator <: Iterator<(Dog, String)> {
    var ccc = 0

    exclave init(this @local!) {}

    public func next(): ?(Dog,String) {
        throw Exception()
    }
    public exclave func next(this @local!): ?(Dog,String)@local! {
        if (ccc == 0) {
            ccc++
            (Dog() @local!, "haha")
        } else {
            None<(Dog, String)>
        }
    }
}
func foo() {
    let tp = TupleIterator() @local!
    for ((k, ss) in tp) {
        println(ss.size)
        k.roat()
    }
}
main() {
    foo()
}