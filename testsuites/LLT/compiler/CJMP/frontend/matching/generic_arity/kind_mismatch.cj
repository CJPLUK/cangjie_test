// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 1
// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir=c
package cmp

public common class C<T, U> {
    public init() {}
}

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %diag_json --experimental p/p.cj --common-part-cjo=c/cmp.cjo --common-part-chir=c/cmp.chir --output-type=staticlib 2>&1 | compare %f
package cmp

public specific struct C<R> {}

// ASSERT: scan-1 specific_has_different_kind
// ASSERT: scan-not sema_generic_member_type_argument_different
// ASSERT: scan-not Internal Compiler Error
