// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir=c
package cmp

public common class C<T, U> where T <: ToString {
    public init() {}
    public func show(value: T): String { value.toString() }
    public common func second(value: U): U
    public func callSecond(value: U): U { second(value) }
}

public common struct S<T, U> {
    public init() {}
    public func second(value: U): U { value }
}

public common interface I<T, U> {
    func first(value: T): T
    func second(value: U): U
}

public common enum E<T, U> {
    First(T) | Second(U)
}

public common func foo<T>(value: T): Unit
public common func foo<T, U>(value: T, other: U): Unit

// SEPARATE-FILE: p/p.cj
// EXEC-0: %compiler %noColor --experimental p/p.cj --common-part-cjo=c/cmp.cjo --common-part-chir=c/cmp.chir -o %output
// RUN: %run %output 2>&1 | compare %f
package cmp

public specific class C<R, V> where R <: ToString {
    public specific func second(value: V): V { value }
}
public specific struct S<R, V> {}
public specific interface I<R, V> {}
public specific enum E<R, V> {
    First(R) | Second(V)
}

// Match overloads in the reverse declaration order.
public specific func foo<R, S>(value: R, other: S): Unit {}
public specific func foo<R>(value: R): Unit {}

class Implementation <: I<Int64, String> {
    public func first(value: Int64): Int64 { value }
    public func second(value: String): String { value }
}

main(): Unit {
    foo<Int64>(1)
    foo<Int64, String>(1, "overload")
    let c = C<Int64, String>()
    println(c.show(42))
    println(c.callSecond("class"))
    println(S<Int64, String>().second("struct"))
    let i: I<Int64, String> = Implementation()
    println(i.first(7))
    println(i.second("interface"))
    let e = E<Int64, String>.Second("enum")
    match (e) {
        case E<Int64, String>.Second(value) => println(value)
        case _ => println("unexpected")
    }
}

/* SCAN
42
class
struct
7
interface
enum
*/
