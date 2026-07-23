// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Boxed {
    Boxed(public var value: Any) {}
}

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "id" => e
            case _ => throw ExternMemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexedAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>(1)
        } else {
            throw Exception("indexedAccess not implemented")
        }
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any) : Unit  {
        match (field) {
            case "something" =>
                let v = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
                v.value = value
            case _ => throw ExternMemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexedUpdate(e: Extern<DummyRT>, index: Any, value: Any): Unit {
        match (index) {
            case i: Int64 =>
                let v = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
                v.value = value
            case _ => throw ExternMemberAccessException("indexedUpdate not implemented")
        }
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        match (Extern<DummyRT>.getPayload(e)) {
            case i: Int64 => match (i) {
                case 1 => Extern<DummyRT>(101)
                case 42 => Extern<DummyRT>(1042)
                case _ => throw ExternFunctionCallException("functionCall not implemented")
            }
            case _ => throw ExternFunctionCallException("functionCall not implemented")
        }
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  =>
                match (Extern<DummyRT>.getPayload(h)) {
                    case b: Boxed => (b.value as R).getOrThrow()
                    case i: Int64 => (i as R).getOrThrow()
                    case _ => throw ExternConversionException("fromExtern not implemented")
                }
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

class A {
    public A(public let e: Extern<DummyRT>) {}
}

struct B {
    public B(public let a: A) {}
}

class C {
    public C(public let b: B) {}
}

func foo(){
    let e1 = Extern<DummyRT>(42)
    C(B(A(e1)))
}

class ExpectedException <: Exception {
    public ExpectedException(s: String) {
        super(s)
    }
}

main () {
    let e1 = Extern<DummyRT>(42)
    let c = C(B(A(e1)))

    // member access nested extern
    let e2 = c.b.a.e.id
    if (DummyRT.fromExtern<Int64>(e2) != 42) {
        throw Exception("test failed")
    }

    // index access nested extern
    let e3 = c.b.a.e[0]
    if (DummyRT.fromExtern<Int64>(e3) != 1) {
        throw Exception("test failed")
    }

    // member update nested extern
    let e4 = Extern<DummyRT>(Boxed(100))
    let c3 = C(B(A(e4)))
    if (DummyRT.fromExtern<Int64>(c3.b.a.e) != 100) {
        throw Exception("test failed")
    }
    c3.b.a.e.something = 1
    if (DummyRT.fromExtern<Int64>(c3.b.a.e) != 1) {
        throw Exception("test failed")
    }

    // index update nested extern
    let e5 = Extern<DummyRT>(Boxed(200))
    let c4 = C(B(A(e5)))
    if (DummyRT.fromExtern<Int64>(c4.b.a.e) != 200) {
        throw Exception("test failed")
    }
    c4.b.a.e[0] = 205
    if (DummyRT.fromExtern<Int64>(c4.b.a.e) != 205) {
        throw Exception("test failed")
    }

    // function call nested extern
    if (DummyRT.fromExtern<Int64>(c.b.a.e()) != 1042) {
        throw Exception("test failed")
    }

    // function call nested extern
    if (DummyRT.fromExtern<Int64>(c.b.a.e.id()) != 1042) {
        throw Exception("test failed")
    }

    // function call nested extern
    if (DummyRT.fromExtern<Int64>(c.b.a.e[0]()) != 101) {
        throw Exception("test failed")
    }

    let b = c.b

    // function call nested extern
    if (DummyRT.fromExtern<Int64>(b.a.e()) != 1042) {
        throw Exception("test failed")
    }
    // function call nested extern
    if (DummyRT.fromExtern<Int64>(b.a.e.id()) != 1042) {
        throw Exception("test failed")
    }
    // function call nested extern
    if (DummyRT.fromExtern<Int64>(b.a.e[0]()) != 101) {
        throw Exception("test failed")
    }

    let a = b.a

    // function call nested extern
    if (DummyRT.fromExtern<Int64>(a.e()) != 1042) {
        throw Exception("test failed")
    }
    // function call nested extern
    if (DummyRT.fromExtern<Int64>(a.e.id()) != 1042) {
        throw Exception("test failed")
    }
    // function call nested extern
    if (DummyRT.fromExtern<Int64>(a.e[0]()) != 101) {
        throw Exception("test failed")
    }

    // function call nested extern
    if (DummyRT.fromExtern<Int64>(foo().b.a.e()) != 1042) {
        throw Exception("test failed")
    }
    // function call nested extern
    if (DummyRT.fromExtern<Int64>(foo().b.a.e.id()) != 1042) {
        throw Exception("test failed")
    }
    // function call nested extern
    if (DummyRT.fromExtern<Int64>(foo().b.a.e[0]()) != 101) {
        throw Exception("test failed")
    }

    try {
        // function call nested extern
        if (DummyRT.fromExtern<Int64>(foo().b.a.e()) != 0) {
            throw ExpectedException("test failed")
        }
        throw Exception("test failed")
    } catch (e: ExpectedException) {
        // expected
    }

    try {
        // function call nested extern
        if (DummyRT.fromExtern<Int64>(foo().b.a.e.id()) != 0) {
            throw ExpectedException("test failed")
        }
        throw Exception("test failed")
    } catch (e: ExpectedException) {
        // expected
    }

    try {
        // function call nested extern
        if (DummyRT.fromExtern<Int64>(foo().b.a.e[0]()) != 0) {
            throw ExpectedException("test failed")
        }
        throw Exception("test failed")
    } catch (e: ExpectedException) {
        // expected
    }

    try {
        // function call nested extern
        Extern<DummyRT>("foooooo")()
        throw Exception("test failed")
    } catch (e: ExternFunctionCallException) {
        // expected
    }

    try {
        // function call nested extern
        Extern<DummyRT>(2)()
        throw Exception("test failed")
    } catch (e: ExternFunctionCallException) {
        // expected
    }

    0
}