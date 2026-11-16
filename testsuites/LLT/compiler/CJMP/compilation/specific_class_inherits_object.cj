// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression test: specific class in common part must have implicit Object superclass
// set up in CHIR. See TranslateClassDecl.cpp::needInitialSuperClassSetup
//
// This test needed because CHIR checker part enabled only in Debug builds

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c
// EXEC-0: %chirDis c/cmp.chir
// EXEC-0: grep -q "1BE <: Class-_CNat6ObjectE" cmp.chirtxt || (echo "FAIL: specific class B must have Object superclass in common CHIR"; grep "class @_CN3cmp1BE" cmp.chirtxt; exit 1)
package cmp

public specific class B {
    public init() {}
}
