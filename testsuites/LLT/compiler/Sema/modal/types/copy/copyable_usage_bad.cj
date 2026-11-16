// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit all 2>&1 | compare %f

interface I<X> {}
interface J {
    func abstractRet(): Copyable
}
func paramType(x: Copyable): Unit {}
func funcTypeParam(g: (Copyable) -> Unit): Unit {}
func funcTypeRet(g: (Int64) -> Copyable): Unit {}
func typeArg(a: Array<Copyable>): Unit {}
func optionArg(a: Option<Copyable>): Unit {}
func opArg(a: ?Copyable): Unit {}
func tupleArg(a: (Copyable, Int64)): Unit {}
func nestedUpperBound<T>(a: T): Unit where T <: I<Copyable> {}

class My {
    init() {}
}
extend My <: Copyable {}

main() {}

// ASSERT: scan-10 "DiagKind": "sema_illegal_copy_type_usage",
// ASSERT: scan "Errors": 10,
