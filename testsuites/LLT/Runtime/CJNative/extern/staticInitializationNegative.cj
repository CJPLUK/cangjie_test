// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-2 global/static variable 'answer' is used before initialization

// The implicit calls to the functions of a foreign runtime are checked for the use of global and static variables
// before their initialization in the initializers of static variables, as the calls written explicitly.

let source = Extern<RT>(0)

class C {
    static let converted: Extern<RT> = 1 // toExtern
    static let accessed = source.f       // memberAccess
}

let answer = 42

class RT <: ForeignRuntime<RT> {
    public static func toExtern<T>(value: T): Extern<RT> {
        Extern<RT>(answer)
    }

    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> {
        Extern<RT>(answer)
    }

    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}

    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> {
        e
    }

    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}

    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        e
    }

    public static func fromExtern<T>(e: Extern<RT>): T {
        throw Exception()
    }
}

main() {
    0
}
