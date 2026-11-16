// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import java.lang.*

@Java
class M {
    // Checks that fields can be String
    var s: String = "s"

    // Checks that member functions can accept & return String
    private func pfoo(s: String): String { s }
    private func pfooImplicitRet(s: String)  { s }

    protected func protfoo(s: String): String { s }
    protected func protfooImplicitRet(s: String) { s }

    internal func interfoo(s: String): String { s }
    internal func interfooImplicitRet(s: String) { s + "." }

    public func pubfoo(s: String): String { s }
    public func pubfooImplicitRet(s: String) { pubfoo(s) }
}
