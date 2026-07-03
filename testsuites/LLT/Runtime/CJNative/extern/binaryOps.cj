// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-8 expected 'Bool', found 'Struct-Extern<Class-DummyRT>'
// ASSERT: scan-8 error: mismatched types

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented") 
    }
    public static func indexAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw Exception("indexAccess not implemented")
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any) : Unit  {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        throw Exception("fromExtern not implemented")
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

main (){
    let e1 = Extern<DummyRT>(1)
    let e2 = Extern<DummyRT>(2)
    if (e1 < e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 <= e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 > e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 >= e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 - e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 + e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 == e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    if (e1 != e2) {
        throw Exception("Extern comparison should not be allowed")
    }
    0
}
