// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// CreateVTable is before MarkClassHasInited; @ObjCImpl must not have `$hasInited`
// yet (field is no longer inserted on AST).

// DEPENDENCE: ../pick_defination.py
// (Darwin) EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj %compile_shared_lib_opt -o %n.%suffix %import_objc_interop
// (Darwin) EXEC: %python pick_defination.py %n\_CHIR/[0-9]*_CreateVTable.chirtxt "class @_CN7default1AE" | compare %f
// (Darwin) ASSERT: regex \[(?P<kind>objCExport)\] class @(?P<cls>_CN7default1AE)
// (Darwin) ASSERT: scan-not $hasInited

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
