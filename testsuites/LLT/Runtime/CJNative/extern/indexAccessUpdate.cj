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

var countIncs: Int64 = 0
var countAdds: Int64 = 0

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        match (field) {
            case "inc" => 
                countIncs = countIncs + 1
                let e = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
                Extern<DummyRT>(Boxed((e.value as Int64).getOrThrow() + 1))
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexedAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexedAccess not implemented")
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(e: Extern<DummyRT>, index: Any, value: Any): Unit {
        match (index) {
            case field: String => match (field) {
                case "add" => 
                    countAdds = countAdds + 1
                    let v = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
                    v.value =  (v.value as Int64).getOrThrow() + (value as Int64).getOrThrow()
                case "set" => 
                    let v = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
                    v.value = value
                case "mutate" => 
                    let v = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
                    let s = (v.value as String).getOrThrow()
                    let c = (value as Rune).getOrThrow()
                    v.value = String([c]) + s[1..]
                case _ => throw MemberAccessException("not implemented")
            }
            case i: Int64 =>
                let array: Array<Int64> = (Extern<DummyRT>.getPayload(e) as Array<Int64>).getOrThrow()
                array[i] = (value as Int64).getOrThrow()
            case _ => throw IndexAccessException("indexedAccess not implemented")
        }
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64>  => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<String>  => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _ => throw Exception("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main () {
    let e1 = Extern<DummyRT>(Boxed(0))
    e1["add"] = 10

    if (DummyRT.fromExtern<Int64>(e1) != 10) {
        throw Exception("test failed")
    }

    e1["set"] = 20
    if (DummyRT.fromExtern<Int64>(e1) != 20) {
        throw Exception("test failed")
    }

    e1["add"] = 1
    if (DummyRT.fromExtern<Int64>(e1) != 21) {
        throw Exception("test failed")
    }

    e1["set"] = "hello"
    if (DummyRT.fromExtern<String>(e1) != "hello") {
        throw Exception("test failed")
    }

    e1["mutate"] = r'a'
    if (DummyRT.fromExtern<String>(e1) != "aello") {
        throw Exception("test failed")
    }

    let e2 = Extern<DummyRT>(Boxed(0))

    let currentCountIncs = countIncs
    let currentCountAdds = countAdds
    
    e2.inc.inc.inc.inc.inc["add"] = 10
    
    if (DummyRT.fromExtern<Int64>(e2) != 0) {
        throw Exception("test failed")
    }

    if (countIncs - currentCountIncs != 5) {
        throw Exception("test failed")
    }

    if (countAdds - currentCountAdds != 1) {
        throw Exception("test failed")
    }

    let array: Array<Int64> = [1, 2, 3, 4, 5]

    let e3 = Extern<DummyRT>(array)

    e3[0] = 10
    if (array[0] != 10 || array[1] != 2 || array[2] != 3 || array[3] != 4 || array[4] != 5) {
        throw Exception("test failed")
    }

    0
}