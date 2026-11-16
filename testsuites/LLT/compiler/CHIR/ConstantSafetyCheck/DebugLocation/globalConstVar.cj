// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Global const initializer keeps DebugLocation on AST_CHIR (before const eval).
// EXEC: %compiler %f %dumpCHIRDebug -Woff all
// EXEC: %cat default_CHIR/[0-9]*_AST_CHIR.chirtxt | compare %f

const str = "Test" + "String"

main(): Int64 {
    return 0
}

// ASSERT: regex-begin Func @_CGV7default3strHv\(\): Unit // loc: "globalConstVar.cj"-12-1
// ASSERT: regex-after Constant\("Test"\) // loc: "globalConstVar.cj"-12-
// ASSERT: regex-after Constant\("String"\) // loc: "globalConstVar.cj"-12-
// ASSERT: regex-after Apply\(Struct-_CNat6StringE->@_CNat6StringplHRNatY0_E, %\d+, %\d+\) // loc: "globalConstVar.cj"-12-
// ASSERT: regex-after Store\(%\d+, @_CN7default3strE\) // loc: "globalConstVar.cj"-12-1
