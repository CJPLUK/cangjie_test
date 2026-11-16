// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

interface I<T> {
    prop first: ?Int64
    prop first: ?Int64 @local?
}
class C <: I<Int64> {
    public prop first: ?Int64 { get() { Some(1) } }
    public prop first: ?Int64 @local? { get() { throw Exception("local? overload") } }
}
interface DefaultI<T> {
    prop first: ?Int64 { get() { Some(2) } }
    prop first: ?Int64 @local?
}
class D <: DefaultI<Int64> {
    public prop first: ?Int64 @local? { get() { throw Exception("local? overload") } }
}
func check(i: I<Int64>, d: DefaultI<Int64>) {
    let a: ?Int64 = i.first
    let b: ?Int64 = d.first
    let hi: I<Int64> @local? = i
    let hd: DefaultI<Int64> @local? = d
    let c: ?Int64 @local? = hi.first
    let e: ?Int64 @local? = hd.first
}
main() {}
