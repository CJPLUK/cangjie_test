// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan error: extending type 'Struct-Extern<Class-DummyRT>' is not allowed

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, _: String): Extern<DummyRT> { e }
    public static func indexedAccess(e: Extern<DummyRT>, _: Any): Extern<DummyRT> { e }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any): Unit {}
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {}
    public static func functionCall(e: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> { e }
    public static func fromExtern<R>(h: Extern<DummyRT>): R { (Extern<DummyRT>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRT> { Extern<DummyRT>(v) }
}

type Z = Extern<DummyRT>
type Y = Z
type X = Y

extend X {}

main() {
    0
}
