// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir=c
package cmp

// Type parameter counts: common = 2, specific = 1.
public common class FewerClass<T, U> {
    public common init()
    public func second(value: U): U { value }
}

public common struct FewerStruct<T, U> {
    public common init()
}

public common interface FewerInterface<T, U> {
    common func convert(value: T): U
}

public common enum FewerEnum<T, U> {
    First(T) | Second(U)
}

// Type parameter counts: common = 1, specific = 2.
public common class `class`<T> where T <: ToString {
    public init() {}
    public func show(value: T): String { value.toString() }
}

public common struct MoreStruct<T> {
    public init() {}
}

public common interface MoreInterface<T> {
    common func identity(value: T): T
}

public common enum MoreEnum<T> {
    Value(T)
}

// Type parameter counts: common = 1, specific = 0.
public common class MissingClass<T> {
    public init() {}
}
public common struct MissingStruct<T> {
    public init() {}
}
public common interface MissingInterface<T> {}
public common enum MissingEnum<T> {
    Value(T)
}

// Type parameter counts: common = 0, specific = 1.
public common class ExtraClass {
    public init() {}
}
public common struct ExtraStruct {
    public init() {}
}
public common interface ExtraInterface {}
public common enum ExtraEnum {
    Value(Int64)
}

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %diag_json --error-count-limit=all --experimental p/p.cj --common-part-cjo=c/cmp.cjo --common-part-chir=c/cmp.chir --output-type=staticlib 2>&1 | compare %f
package cmp

public specific class FewerClass<R> {}
public specific struct FewerStruct<R> {}
public specific interface FewerInterface<R> {
    specific func convert(value: R): R
}
public specific enum FewerEnum<R> {
    First(R) | Second(R)
}

public specific class `class`<R, V> where R <: ToString {}
public specific struct MoreStruct<R, U> {}
public specific interface MoreInterface<R, U> {
    specific func identity(value: R): R
}
public specific enum MoreEnum<R, U> {
    Value(R)
}

public specific class MissingClass {}
public specific struct MissingStruct {}
public specific interface MissingInterface {}
public specific enum MissingEnum {
    Value(Int64)
}

public specific class ExtraClass<R> {}
public specific struct ExtraStruct<R> {}
public specific interface ExtraInterface<R> {}
public specific enum ExtraEnum<R> {
    Value(Int64)
}

// ASSERT: scan-16 sema_generic_member_type_argument_different
// ASSERT: scan-1 'specific' class 'FewerClass' type parameter count is 1, but its 'common' declaration requires 2
// ASSERT: scan-1 'specific' struct 'FewerStruct' type parameter count is 1, but its 'common' declaration requires 2
// ASSERT: scan-1 'specific' interface 'FewerInterface' type parameter count is 1, but its 'common' declaration requires 2
// ASSERT: scan-1 'specific' enum 'FewerEnum' type parameter count is 1, but its 'common' declaration requires 2
// ASSERT: scan-1 'specific' class '`class`' type parameter count is 2, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' struct 'MoreStruct' type parameter count is 2, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' interface 'MoreInterface' type parameter count is 2, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' enum 'MoreEnum' type parameter count is 2, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' class 'MissingClass' type parameter count is 0, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' struct 'MissingStruct' type parameter count is 0, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' interface 'MissingInterface' type parameter count is 0, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' enum 'MissingEnum' type parameter count is 0, but its 'common' declaration requires 1
// ASSERT: scan-1 'specific' class 'ExtraClass' type parameter count is 1, but its 'common' declaration requires 0
// ASSERT: scan-1 'specific' struct 'ExtraStruct' type parameter count is 1, but its 'common' declaration requires 0
// ASSERT: scan-1 'specific' interface 'ExtraInterface' type parameter count is 1, but its 'common' declaration requires 0
// ASSERT: scan-1 'specific' enum 'ExtraEnum' type parameter count is 1, but its 'common' declaration requires 0
// ASSERT: scan-16 'common' declaration is here
// ASSERT: scan-not sema_not_matched
// ASSERT: scan-1 "Errors": 16,
// ASSERT: scan-not Internal Compiler Error
