// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// CreateVTable runs before MarkClassHasInited. After moving `$hasInited` off AST,
// a @JavaMirror must not carry the field yet at this stage.

// DEPENDENCE: ../pick_defination.py
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj %compile_shared_lib_opt -o %n.%suffix %import_java_interop
// (CJNATIVE and not Windows) EXEC: %python pick_defination.py %n\_CHIR/[0-9]*_CreateVTable.chirtxt "class @_CN7default1ME" | compare %f
// (CJNATIVE and not Windows) ASSERT: regex \[(?P<kind>javaForeign)\] class @(?P<cls>_CN7default1ME)
// (CJNATIVE and not Windows) ASSERT: scan-not $hasInited

import java.lang.*

@JavaMirror
class M {
    init()
}
