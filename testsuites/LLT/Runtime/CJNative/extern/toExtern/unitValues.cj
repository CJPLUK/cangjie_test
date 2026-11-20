// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Expressions of type Unit, such as loops, an if without else, a try with resources and a block ending with a
// declaration, are converted as a whole: the unit value is converted.

var units = 0

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        if (v is Unit) {
            units++
        }
        Extern<DummyRT>(v)
    }
}

class Res <: Resource {
    public func isClosed(): Bool {
        false
    }

    public func close(): Unit {}
}

func declLast(): Extern<DummyRT> {
    let z = 1
}

func loopBody(): Extern<DummyRT> {
    while (false) {}
}

main() {
    let c = false
    let noElse: Extern<DummyRT> = if (c) { 1 }
    let withResources: Extern<DummyRT> = try (r = Res()) { 1 } catch (e: Exception) { 2 }
    let w: Extern<DummyRT> = while (c) {}
    let dw: Extern<DummyRT> = do {} while (c)
    let f: Extern<DummyRT> = for (_ in 0..2) {}
    let values = [noElse, withResources, w, dw, f, declLast(), loopBody()]
    for (value in values) {
        DummyRT.fromExtern<Unit>(value)
    }
    if (units != 7) {
        throw Exception("expected 7 converted unit values, got ${units}")
    }
    0
}
