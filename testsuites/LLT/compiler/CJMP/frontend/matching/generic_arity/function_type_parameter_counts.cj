// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// Functions with different type parameter counts are separate matching candidates.
// The String overload must still match when the Int64 overload does not.
// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir=c
package cmp

public common func fewer<T, U>(): Unit
public common func more<T>(): Unit
public common func missing<T>(): Unit
public common func extra(): Unit
public common func mapped<T, U>(value: Array<T>): Unit
public common class C<T> {
    public init() {}
    public common func member<U, V>(value: T, other: U): Unit
}

public common func foo<T, U>(value: Int64): Unit
public common func foo<T>(value: String): Unit

public common func unrelated<T, U>(value: String): Unit
public common func extraUsed<T, U>(value: U): Unit
public common func differentParams<T, U>(value: Int64, other: String): Unit
public common func named<T, U>(first!: Int64): Unit

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %diag_json --error-count-limit=all --experimental p/p.cj --common-part-cjo=c/cmp.cjo --common-part-chir=c/cmp.chir --output-type=staticlib 2>&1 | compare %f
package cmp

public specific func fewer<R>(): Unit {}
public specific func more<R, S>(): Unit {}
public specific func missing(): Unit {}
public specific func extra<R>(): Unit {}
public specific func mapped<R>(value: Array<R>): Unit {}
public specific class C<R> {
    public specific func member<S>(value: R, other: S): Unit {}
}

public specific func foo<R>(value: Int64): Unit {}
public specific func foo<R>(value: String): Unit {}

public specific func unrelated<R>(value: Int64): Unit {}
public specific func extraUsed<R>(value: R): Unit {}
public specific func differentParams<R>(value: Int64): Unit {}
public specific func named<R>(second!: Int64): Unit {}

// ASSERT: scan-22 sema_not_matched
// ASSERT: scan-1 'specific' function 'fewer' can not find 'common' match
// ASSERT: scan-1 'common' function 'fewer' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'more' can not find 'common' match
// ASSERT: scan-1 'common' function 'more' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'missing' can not find 'common' match
// ASSERT: scan-1 'common' function 'missing' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'extra' can not find 'common' match
// ASSERT: scan-1 'common' function 'extra' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'mapped' can not find 'common' match
// ASSERT: scan-1 'common' function 'mapped' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'member' can not find 'common' match
// ASSERT: scan-1 'common' function 'member' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'foo' can not find 'common' match
// ASSERT: scan-1 'common' function 'foo' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'unrelated' can not find 'common' match
// ASSERT: scan-1 'common' function 'unrelated' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'extraUsed' can not find 'common' match
// ASSERT: scan-1 'common' function 'extraUsed' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'differentParams' can not find 'common' match
// ASSERT: scan-1 'common' function 'differentParams' can not find 'specific' match
// ASSERT: scan-1 'specific' function 'named' can not find 'common' match
// ASSERT: scan-1 'common' function 'named' can not find 'specific' match
// ASSERT: scan-not sema_generic_member_type_argument_different
// ASSERT: scan-1 "Errors": 22,
// ASSERT: scan-not Internal Compiler Error
