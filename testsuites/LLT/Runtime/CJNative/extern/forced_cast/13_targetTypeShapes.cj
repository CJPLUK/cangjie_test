// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The target `U` in a forced cast may take type shapes beyond a plain or generic
// name: a package-qualified type (QualifiedType, e.g. `collection.ArrayList`), a
// function type, a tuple type, and an option type. All resolve through
// Runtime.fromExtern. Two qualified classes from the same package confirm it is the
// shape that is handled, not one particular type.

import std.collection

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

main() {
    // Package-qualified target types (QualifiedType), two classes from std.collection.
    let listExtern = Extern<DummyRuntime>(collection.ArrayList<Int64>([3]))
    let list: collection.ArrayList<Int64> = (collection.ArrayList<Int64>)listExtern

    let map = collection.HashMap<String, Int64>()
    map["k"] = 4
    let mapExtern = Extern<DummyRuntime>(map)
    let unwrappedMap: collection.HashMap<String, Int64> = (collection.HashMap<String, Int64>)mapExtern

    // Function type target.
    let fnExtern = Extern<DummyRuntime>({x: Int64 => x + 10})
    let fn = ((Int64) -> Int64)fnExtern

    // Tuple type target.
    let tupleExtern = Extern<DummyRuntime>((6, "a"))
    let tuple = ((Int64, String))tupleExtern

    // Option type target.
    let optionValue: ?Int64 = Some(7)
    let optionExtern = Extern<DummyRuntime>(optionValue)
    let option = (?Int64)optionExtern

    if (list[0] != 3 || unwrappedMap["k"] != 4 || fn(5) != 15 ||
        tuple[0] != 6 || tuple[1] != "a" || option.getOrThrow() != 7) {
        throw Exception("target type shape forced cast failed")
    }
}
