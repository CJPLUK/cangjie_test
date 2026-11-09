// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
class Dog {
    init() {}
    exclave init(this @local!) {}
    exclave init(this @local?) {}
    func roar() { 3 }
    func roat(this @local!) {4}
    func roam(this @local?) {5}
}
class Bam <: Iterator<Dog> {
    var ccc = 0

    public init() {}
    public exclave init(this @local!) {}
    public exclave init(this @local?) {}

    public func next() {
        if (ccc<5) { ccc++; Dog() }
        else { None<Dog> }
    }
    public exclave func next(this @local!): ?Dog@local! {
        if (ccc<5) { ccc++; Dog() @local!}
        else { None<Dog> }
    }
    public exclave func next(this @local?) {
        if (ccc<5) { ccc++; Dog() @local? }
        else { None<Dog> }
    }
}
main() {
    let b = Bam()
    for (i in b) {
        i.roar()
    }
    let b2 = Bam()@local!
    for (i in b2) {
        i.roat()
    }
    let b3=Bam()@local?
    for (i in b3) {
        i.roam()
    }
}