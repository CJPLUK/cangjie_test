// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// @ObjCImpl used to get `$hasInited` from AST InsertFinalizer. It is now added
// only in CHIR MarkClassHasInited.

// DEPENDENCE: ../pick_defination.py
// (Darwin) EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj %compile_shared_lib_opt -o %n.%suffix %import_objc_interop
// (Darwin) EXEC: %python pick_defination.py %n\_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN7default1AE" | compare %f
// (Darwin) ASSERT: regex \[(?P<kind>objCExport)\] class @(?P<cls>_CN7default1AE)[\s\S]*?\[private\] \[compilerAdd\] \[noReflectInfo\] var \$hasInited: Bool

import objc.lang.*

@ObjCMirror
public open class M {
    init()
}

@ObjCImpl
public class A <: M {
    public init() {
        super()
    }
}
