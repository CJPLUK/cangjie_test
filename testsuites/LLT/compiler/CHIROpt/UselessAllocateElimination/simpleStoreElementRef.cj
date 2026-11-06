// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_RedundantLoadElimination.chirtxt "Func @_CN7default6<main>Hv" | compare %f --assert_flag=ASSERT_BEFORE
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default6<main>Hv" | compare %f

struct A {
    var a = 1
}

main() {
    var a = A()
    a.a = 3
}

// ASSERT_BEFORE: regex-2 = Allocate\(Struct-_CN7default1AE\)
// ASSERT_BEFORE: regex-2 = StoreElementRef\(

// ASSERT: regex-1 = Allocate\(Struct-_CN7default1AE\)
// ASSERT: regex-1 = StoreElementRef\(
// ASSERT: regex-begin \[ret\] %(?P<ret>\d+): Unit& = Allocate\(Unit\)
// ASSERT: regex-after %(?P<temporary>\d+): Struct-_CN7default1AE& = Allocate\(Struct-_CN7default1AE\)
// ASSERT: regex-after %(?P<initial>\d+): Int64 = Constant\(1i\)
// ASSERT: regex-after Unit = StoreElementRef\(%(?P=initial), %(?P=temporary), 0\)
// ASSERT: regex-after Struct-_CN7default1AE = Load\(%(?P=temporary)\)
// ASSERT: regex-after %(?P<unit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after Unit = Store\(%(?P=unit), %(?P=ret)\)
