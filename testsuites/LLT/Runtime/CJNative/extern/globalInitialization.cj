// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The implicit calls to the functions of a foreign runtime may use the global and static variables that are
// initialized before them.

let answer = 42
var updates = 0

let source = Extern<RT>(0)
let converted: Extern<RT> = 1             // toExtern
let accessed = source.f                   // memberAccess
let indexed = source[0]                   // indexedAccess
let called = source(2)                    // functionCall
let updated = { => source.f = 3 }()       // memberUpdate
let indexUpdated = { => source[0] = 4 }() // indexedUpdate

class C {
    static let converted: Extern<RT> = 5 // toExtern
    static let accessed = source.g       // memberAccess
}

class RT <: ForeignRuntime<RT> {
    public static func toExtern<T>(value: T): Extern<RT> {
        Extern<RT>(answer)
    }

    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> {
        Extern<RT>(answer + 1)
    }

    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {
        updates += answer
    }

    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> {
        Extern<RT>(answer + 2)
    }

    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {
        updates += answer
    }

    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> {
        Extern<RT>(answer + 3)
    }

    public static func fromExtern<T>(e: Extern<RT>): T {
        throw Exception()
    }
}

func payload(e: Extern<RT>): Int64 {
    (Extern<RT>.getPayload(e) as Int64).getOrThrow()
}

main() {
    if (payload(converted) != 42 || payload(accessed) != 43 || payload(indexed) != 44 || payload(called) != 45) {
        return 1
    }
    if (updates != 84) {
        return 2
    }
    if (payload(C.converted) != 42 || payload(C.accessed) != 43) {
        return 3
    }
    0
}
