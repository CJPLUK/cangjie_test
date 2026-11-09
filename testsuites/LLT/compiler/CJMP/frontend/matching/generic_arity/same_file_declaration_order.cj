// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir=c
package cmp

public func marker(): Unit {}

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %diag_json --experimental p/p.cj --common-part-cjo=c/cmp.cjo --common-part-chir=c/cmp.chir --output-type=staticlib 2>&1 | compare %f
package cmp

public specific class SpecificFirst<R> {}
public common class SpecificFirst<T, U> {
    public common init()
}

public common class CommonFirst<T, U> {
    public common init()
}
public specific class CommonFirst<R> {}

public specific interface NonGenericFirst {}
public common interface NonGenericFirst<T> {}

public common interface GenericFirst {}
public specific interface GenericFirst<R> {}

// ASSERT: scan-4 sema_generic_member_type_argument_different
// ASSERT: scan 'specific' class 'SpecificFirst' type parameter count is 1, but its 'common' declaration requires 2
// ASSERT: scan 'specific' class 'CommonFirst' type parameter count is 1, but its 'common' declaration requires 2
// ASSERT: scan 'specific' interface 'NonGenericFirst' type parameter count is 0, but its 'common' declaration requires 1
// ASSERT: scan 'specific' interface 'GenericFirst' type parameter count is 1, but its 'common' declaration requires 0
// ASSERT: scan-4 'common' declaration is here
// ASSERT: scan-not sema_not_matched
// ASSERT: scan-not Internal Compiler Error
