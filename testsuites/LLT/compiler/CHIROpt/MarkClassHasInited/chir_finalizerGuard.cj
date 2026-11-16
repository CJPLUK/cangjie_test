// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// MarkClassHasInited prepends a new entry block that loads `$hasInited` and
// branches to the original body only when the flag is true; otherwise Exit.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1C5~initHv" | compare %f
// ASSERT: regex %(?P<fieldRef>\d+): Bool& = GetElementRef\(%0, 0\)[\s\S]*?%(?P<flag>\d+): Bool = Load\(%(?P=fieldRef)\)[\s\S]*?Branch\(%(?P=flag), #(?P<body>\d+), #(?P<early>\d+)\)
// ASSERT: regex Block #(?P=early):[\s\S]*?Exit\(
// ASSERT: regex Block #(?P=body):[\s\S]*?println[\s\S]*?Exit\(

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
