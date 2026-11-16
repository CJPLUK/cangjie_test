// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %cmp_opt %enableConstPropagation %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_ConstantPropagation.chirtxt "Func @_CN7default3fooHb" | compare %f
// RUN-EXEC-PIPE-0: %run main
// Both sides store true; Load(x) after join is Constant("true"). Condition is not const so Branch stays.
// ASSERT: scan Branch(
// ASSERT: scan Constant(true)
// ASSERT: scan-not Load(

func foo(b: Bool) {
    var x = true
    if (b) {
        x = true
    }
    return x
}

main() {
    foo(false)
    0
}
