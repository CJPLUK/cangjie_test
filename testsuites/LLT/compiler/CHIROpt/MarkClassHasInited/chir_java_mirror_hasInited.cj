// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// @JavaMirror used to get `$hasInited` from AST desugar. It is now added only in
// CHIR MarkClassHasInited (mirror still gets a compiler finalizer on AST).

// DEPENDENCE: ../pick_defination.py
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj %compile_shared_lib_opt -o %n.%suffix %import_java_interop
// (CJNATIVE and not Windows) EXEC: %python pick_defination.py %n\_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN7default1ME" | compare %f
// (CJNATIVE and not Windows) ASSERT: regex \[(?P<kind>javaForeign)\] class @(?P<cls>_CN7default1ME)[\s\S]*?\[private\] \[compilerAdd\] \[noReflectInfo\] var \$hasInited: Bool

import java.lang.*

@JavaMirror
class M {
    init()
}
