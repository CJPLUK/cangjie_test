// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RaiseException is not an Exit: MarkClassHasInited only stores false at the
// constructor head. The throw path therefore leaves `$hasInited` false so the
// finalizer guard skips the body (covered by test1 at runtime).

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1C6<init>Hv" | compare %f
// ASSERT: regex Constant\(false\)[\s\S]*?StoreElementRef\(%\d+, %0, 1\)
// ASSERT: scan RaiseException(
// ASSERT: regex RaiseException\(%\d+\)

class C {
    var x: Int64
    init() {
        throw Exception("construct C exception")
    }
    ~init() {
        println(x)
    }
}

main(): Int64 {
    try {
        C()
    } catch (_: Exception) {
    }
    0
}
