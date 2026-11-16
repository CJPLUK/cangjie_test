// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// MarkClassHasInited writes `$hasInited = false` at the constructor entry and
// `$hasInited = true` before every Exit. Empty class: field index is 0.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1C6<init>Hv" | compare %f
// ASSERT: regex %(?P<falseVal>\d+): Bool = Constant\(false\)[\s\S]*?StoreElementRef\(%(?P=falseVal), %0, 0\)
// ASSERT: regex %(?P<trueVal>\d+): Bool = Constant\(true\)[\s\S]*?StoreElementRef\(%(?P=trueVal), %0, 0\)[\s\S]*?Exit\(

class C {
    init() {
    }
    ~init() {
        println(1)
    }
}

main(): Int64 {
    C()
    0
}
