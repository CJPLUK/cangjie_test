// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-1 cannot convert an integer literal to type 'Struct-String'
// ASSERT: scan-1 cannot convert an integer literal to type 'Bool'
// ASSERT: scan-1 undeclared identifier 'undefinedName'
// ASSERT: scan-1 3 errors generated
// ASSERT: scan-not semantic error
// ASSERT: scan-not Assertion

// A lambda argument for an Extern<RT> parameter of a generic call is synthesized and then checked again against its own
// type, so that the types of the nodes in its body are not left ideal. The check is only repeated when synthesis
// succeeded, so each error in the body is reported once.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { (Extern.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<RT> { Extern<RT>(v) }
}

func plain<T>(p: Extern<RT>, x: T): T { x }

main() {
    plain({ => let s: String = 1; 1 }, 2)
    plain({ => undefinedName + 1 }, 2)
    plain({ => { => let b: Bool = 1; 1 }; 1 }, 2)
}
