// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.HashMap

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "id" => e
            case "pi" => Extern<DummyRT>(3.14)
            case "add"=> Extern<DummyRT>((getPayload(e) as Int64).getOrThrow() + 1)
            case "sub"=> Extern<DummyRT>((getPayload(e) as Int64).getOrThrow() - 1)
            case "foo" => Extern<DummyRT>({input: Array<Any> =>
                Extern<DummyRT>("function call with input size ${input.size}")})
            case "bar" => Extern<DummyRT>({input: String => "function call with input ${input}"})
            case "baz" => 
                let f : (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> =
                    {arg1: Extern<DummyRT>,  arg2: Extern<DummyRT> =>
                        let s1 = (getPayload(arg1) as String).getOrThrow()
                        let s2 = (getPayload(arg2) as String).getOrThrow()
                        return Extern<DummyRT>("function call with input ${s1} and ${s2}")}
                Extern<DummyRT>(f)
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        if (index is Int64) {
            Extern<DummyRT>((getPayload(e) as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
        } else if (index is String) {
            Extern<DummyRT>((getPayload(e) as HashMap<String, Array<Int64>>).getOrThrow()[(index as String).getOrThrow()])
        } else if (index is Extern<DummyRT>) {
            (index as Extern<DummyRT>).getOrThrow()
        } else {
            throw Exception("indexAccess not implemented")
        }
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        match (getPayload(e)) {
            case i: Int64 => match (i) {
                case 1 => Extern<DummyRT>(101)
                case _ => throw Exception("functionCall not implemented")
            }
            case f: (Array<Any>) -> Extern<DummyRT>  => f(args)
            case g: (String) -> String => Extern<DummyRT>(g((args[0] as String).getOrThrow()))
            case h: (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> => h((args[0] as Extern<DummyRT>).getOrThrow(), (args[1] as Extern<DummyRT>).getOrThrow())
            case _ => throw Exception("functionCall not implemented")
        }
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => (getPayload(h) as R).getOrThrow()
            case _: Option<Float64> => (getPayload(h) as R).getOrThrow()
            case _: Option<Rune> => (getPayload(h) as R).getOrThrow()
            case _: Option<UInt32> => (getPayload(h) as R).getOrThrow()
            case _: Option<Int32> => (getPayload(h) as R).getOrThrow()
            case _: Option<HashMap<String, Array<Int64>>> => (getPayload(h) as R).getOrThrow()
            case _: Option<String> => (getPayload(h) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

func foo<T>() where T <: Runtime<T> {
    let e1 = Extern<T>(1)
    if (T.fromExtern<Int64>(e1()) != 101) {
        throw Exception("test failed")
    }

    if (T.fromExtern<Int64>(e1.id()) != 101) {
        throw Exception("test failed")
    }

    if (T.fromExtern<Int64>(e1.id.id.id.id()) != 101) {
        throw Exception("test failed")
    }

    if (T.fromExtern<Int64>(e1.id.id.id.id.sub.add()) != 101) {
        throw Exception("test failed")
    }

    let m: HashMap<String, Array<Int64>> = HashMap<String, Array<Int64>>()
    let e2 = Extern<T>(m)
    m["one"] = [1, 2, 3]
    if (T.fromExtern<Int64>(e2["one"][0].id()) != 101) {
        throw Exception("test failed")
    }

    if (T.fromExtern<Int64>(e2.id["one"].id[0]()) != 101) {
        throw Exception("test failed")
    }

    if (T.fromExtern<String>(e2.foo()) != "function call with input size 0") {
        throw Exception("test failed")
    }

    if (T.fromExtern<String>(e2.foo(1, 2, 3)) != "function call with input size 3") {
        throw Exception("test failed")
    }

    if (T.fromExtern<String>(e2.bar("hello")) != "function call with input hello") {
        throw Exception("test failed")
    }

    let e3 = Extern<T>("one")
    let e4 = Extern<T>("two") 
    if (T.fromExtern<String>(e2.baz(e3, e4)) != "function call with input one and two") {
        throw Exception("test failed")
    }
    0
}

main () {
    foo<DummyRT>()
}