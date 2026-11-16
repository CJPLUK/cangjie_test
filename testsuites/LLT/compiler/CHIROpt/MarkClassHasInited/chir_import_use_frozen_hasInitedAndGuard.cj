// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Downstream import of a `@Frozen` finalizer: the body is available again, so
// MarkClassHasInited must behave like the defining package — insert `$hasInited`
// and prepend the finalizer guard. Field index is 1 (`x` is 0). Needs -O2.

// DEPENDENCE: ../pick_defination.py chir_import_frozen_pkg.cj
// EXEC: %compiler %cmp_opt %enableO2 %compile_lib_opt chir_import_frozen_pkg.cj -o pkg.%middle
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff all pkg.%middle %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN3pkg6HandleE" > _frozen_pick.txt
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN3pkg6Handle5~initHv" >> _frozen_pick.txt
// EXEC: %cat _frozen_pick.txt | compare %f
// ASSERT: regex \[imported\] class @(?P<cls>_CN3pkg6HandleE)[\s\S]*?\[private\] \[compilerAdd\] \[noReflectInfo\] var \$hasInited: Bool
// ASSERT: scan-1 $hasInited
// ASSERT: regex %(?P<fieldRef>\d+): Bool& = GetElementRef\(%0, 1\)[\s\S]*?%(?P<flag>\d+): Bool = Load\(%(?P=fieldRef)\)[\s\S]*?Branch\(%(?P=flag), #(?P<body>\d+), #(?P<early>\d+)\)
// ASSERT: regex Block #(?P=early):[\s\S]*?Exit\(
// ASSERT: regex Block #(?P=body):[\s\S]*?println[\s\S]*?Exit\(

internal import pkg.*

main(): Int64 {
    Handle()
    0
}
