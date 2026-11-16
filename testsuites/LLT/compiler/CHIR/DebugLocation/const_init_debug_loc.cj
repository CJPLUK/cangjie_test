// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Const global initializers keep source locations. The short-circuit edge of `||`
// is attributed to the whole expression, not the unevaluated right operand.
// Checked on 0_AST_CHIR, before const evaluation removes the initializer body.
// EXEC: %compiler %f %dumpCHIRDebug -Woff all
// EXEC: %cat default_CHIR/[0-9]*_AST_CHIR.chirtxt | compare %f

const constStraight: Int64 = 1 + 2
let letOr: Bool = true ||
    false
const constOr: Bool = true ||
    false
let letAnd: Bool = false &&
    true
const constIf: Int64 = if (false) {
    11
} else {
    22
}
const (constPatA, constPatB) = (6, 7)

main(): Int64 {
    return constStraight
}

// ASSERT: regex-begin Func @_CGV7default13constStraightHv\(\): Unit // loc: "const_init_debug_loc.cj"-14-1
// ASSERT: regex-after Constant\(1i\) // loc: "const_init_debug_loc.cj"-14-
// ASSERT: regex-after Constant\(2i\) // loc: "const_init_debug_loc.cj"-14-
// ASSERT: regex-after Add\(%\d+, %\d+\) // loc: "const_init_debug_loc.cj"-14-
// ASSERT: regex-after Store\(%\d+, @_CN7default13constStraightE\) // loc: "const_init_debug_loc.cj"-14-1

// `true` on the taken edge of `||` must use the `||` line, not the following `false` line.
// ASSERT: regex-begin Func @_CGV7default5letOrHv\(\): Unit // loc: "const_init_debug_loc.cj"-15-1
// ASSERT: regex-after Constant\(true\) // loc: "const_init_debug_loc.cj"-15-
// ASSERT: regex-after Store\(%\d+, %\d+\) // loc: "const_init_debug_loc.cj"-15-
// ASSERT: regex-after Constant\(false\) // loc: "const_init_debug_loc.cj"-16-

// ASSERT: regex-begin Func @_CGV7default7constOrHv\(\): Unit // loc: "const_init_debug_loc.cj"-17-1
// ASSERT: regex-after Constant\(true\) // loc: "const_init_debug_loc.cj"-17-
// ASSERT: regex-after Store\(%\d+, %\d+\) // loc: "const_init_debug_loc.cj"-17-
// ASSERT: regex-after Constant\(false\) // loc: "const_init_debug_loc.cj"-18-
// ASSERT: regex-after Store\(%\d+, @_CN7default7constOrE\) // loc: "const_init_debug_loc.cj"-17-1

// Short-circuit `false` of `&&` stays on the `&&` line. The right operand keeps its own line.
// ASSERT: regex-begin Func @_CGV7default6letAndHv\(\): Unit // loc: "const_init_debug_loc.cj"-19-1
// ASSERT: regex-after Constant\(false\) // loc: "const_init_debug_loc.cj"-19-
// ASSERT: regex-after Constant\(true\) // loc: "const_init_debug_loc.cj"-20-
// ASSERT: regex-after Constant\(false\) // loc: "const_init_debug_loc.cj"-19-

// ASSERT: regex-begin Func @_CGV7default7constIfHv\(\): Unit // loc: "const_init_debug_loc.cj"-21-1
// ASSERT: regex-after Constant\(11i\) // loc: "const_init_debug_loc.cj"-22-
// ASSERT: regex-after Constant\(22i\) // loc: "const_init_debug_loc.cj"-24-

// ASSERT: regex-begin Func @_CGV7default9constPatAHv\(\): Unit // loc: "const_init_debug_loc.cj"-26-1
// ASSERT: regex-after Constant\(6i\) // loc: "const_init_debug_loc.cj"-26-
// ASSERT: regex-after Constant\(7i\) // loc: "const_init_debug_loc.cj"-26-
