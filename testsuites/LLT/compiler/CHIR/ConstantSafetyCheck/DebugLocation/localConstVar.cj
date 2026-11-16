// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Local const inside a function also keeps DebugLocation on AST_CHIR.
// EXEC: %compiler %f %dumpCHIRDebug -Woff all
// EXEC: %cat default_CHIR/[0-9]*_AST_CHIR.chirtxt | compare %f

func foo() {
    const str = "Test" + "String"
}

main(): Int64 {
    foo()
    return 0
}

// ASSERT: regex-begin Func @_CGV7default3fooHvE3strK_Hv\(\): Unit // loc: "localConstVar.cj"-13-5
// ASSERT: regex-after Constant\("Test"\) // loc: "localConstVar.cj"-13-
// ASSERT: regex-after Constant\("String"\) // loc: "localConstVar.cj"-13-
// ASSERT: regex-after Apply\(Struct-_CNat6StringE->@_CNat6StringplHRNatY0_E, %\d+, %\d+\) // loc: "localConstVar.cj"-13-
// ASSERT: regex-after Store\(%\d+, @_CN7default3fooHvE3strK_E\) // loc: "localConstVar.cj"-13-5
