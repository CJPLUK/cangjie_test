// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct S <: Copyable {
    var value: Int64 = 0
    init() {}
    exclave init(this @local!) {}
}
class Holder {
    static let count: Int64 @~local = 0
    var value: S
    exclave init(this @local!) { value = S() @local! }
}
func setExternal(h: Holder @local!) {
    h.value = S() @local!
}
func setMaybe(h: Holder @local?) {
    h.value = S() @local!
}
class GenericHolder<T> where T <: Copyable {
    var value: T
    var pair: (T, T)
    exclave init(this @local!, x: T @local!) {
        value = x
        pair = (x, x)
    }
}
func setGeneric<T>(h: GenericHolder<T> @local?, x: T @local!) where T <: Copyable {
    h.value = x
    h.pair = (x, x)
}
main(): Int64 {
    let h = Holder() @local!
    setExternal(h)
    setMaybe(h)
    let g = GenericHolder<S>(S() @local!) @local!
    setGeneric(g, S() @local!)
    let s = S()
    if (!(s is S)) { return 1 }
    try {} catch (e: Exception) { return 1 }
    h.value.value
}
