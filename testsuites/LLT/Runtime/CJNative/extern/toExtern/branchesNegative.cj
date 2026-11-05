// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan types Int64 and Struct-String of the two branches of this 'if' expression mismatch
// ASSERT: scan type incompatible in this MatchCase
// ASSERT: scan The type of this catch block is 'Struct-String', which mismatches the smallest common supertype 'Int64' of previous branches.
// ASSERT: scan 4 errors generated
// ASSERT: scan-not Assertion

// An if, a match or a try is converted as a whole, so its branches need a common type.

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
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func pick(c: Bool): Extern<DummyRT> {
    if (c) {
        1
    } else {
        "one"
    }
}

main() {
    let c = true
    let ifValue: Extern<DummyRT> = if (c) { 1 } else { "a" }
    let matchValue: Extern<DummyRT> = match (c) {
        case true => "yes"
        case false => 0
    }
    let tryValue: Extern<DummyRT> = try { 1 } catch (_: Exception) { "caught" }
    0
}
