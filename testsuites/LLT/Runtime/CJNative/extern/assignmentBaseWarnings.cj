// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-7 warning: unreachable pattern
// ASSERT: scan-not error:
// ASSERT: scan-not Assertion

// The base of a member or index assignment is synthesized first to find out whether the assignment is a dynamic update
// of a value of type Extern<T>. Its diagnostics are reported once, for ordinary and dynamic updates: each assignment
// below has one unreachable pattern in its base.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { (Extern.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<RT> { Extern<RT>(v) }
}

class P {
    var x = 0
}

class H {
    var p = P()
    var e = Extern<RT>(0)
}

let h = H()
var grid = [[1, 2], [3, 4]]

func get(_: Int64): H { h }

main() {
    // Ordinary member, compound and index assignments.
    get(match (1) { case _ => 0 case 1 => 1 }).p.x = 1
    get(match (1) { case _ => 0 case 1 => 1 }).p.x += 1
    grid[match (1) { case _ => 0 case 1 => 1 }][0] = 1
    get({ => match (1) { case _ => 0 case 1 => 1 } }()).p.x = 1
    // Dynamic member, compound and index updates.
    get(match (1) { case _ => 0 case 1 => 1 }).e.f = 1
    get(match (1) { case _ => 0 case 1 => 1 }).e.f += 1
    get(match (1) { case _ => 0 case 1 => 1 }).e[0] = 1
}
