// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Every Exit in a constructor gets `$hasInited = true`, including early returns.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1C6<init>Hb" | compare %f
// ASSERT: scan Constant(false)
// ASSERT: scan-2 Constant(true)
// ASSERT: regex Constant\(false\)[\s\S]*?StoreElementRef\(%\d+, %0, 0\)
// ASSERT: regex Constant\(true\)[\s\S]*?StoreElementRef\(%\d+, %0, 0\)[\s\S]*?Exit\(
// ASSERT: regex Branch\(%\d+, #\d+, #\d+\)

class C {
    init(early: Bool) {
        if (early) {
            return
        }
    }
    ~init() {
        println(1)
    }
}

main(): Int64 {
    C(true)
    C(false)
    0
}
