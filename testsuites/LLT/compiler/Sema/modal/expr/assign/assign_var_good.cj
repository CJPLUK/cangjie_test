// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

class C {
    var a = 1
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

func getExternal(p: C@local!): C@local! {
    p
}

func testNotToNot() {
    var a: C = C()
    var b: C = C()
    a = b
}

func testHalfCanReceiveAnything(p: C@local!) {
    var h: C@local? = C()
    var a: C = C()
    h = a
    var b: C@local? = C()
    h = b
    var c: C@local! = C()
    h = c
    h = p
}

func testHalfCanReceiveInternal() {
    var a: C@local? = C()
    var b: C@local! = C()
    a = b
}

func testHalfCanReceiveExternal(p: C@local!) {
    var a: C@local? = C()
    a = p
}

func testInternalToInternal() {
    var a: C@local! = C()
    var b: C@local! = C()
    a = b
}

main() {
    testNotToNot()
    testHalfCanReceiveAnything(C() @local!)
    testInternalToInternal()
}

