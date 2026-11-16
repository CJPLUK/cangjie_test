// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-compares -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

var fooCounter = 0
var gooCounter = 0

func foo(): Bool {
    if (goo() == hoo()) {
        ()
    }

    let _ = goo() == 0

    return false
}

func hoo() {
    fooCounter++
    fooCounter
}

func goo() {
    gooCounter++
    gooCounter
}

main() {
    foo()
    println("fooCounter = ${fooCounter}")
    println("gooCounter = ${gooCounter}")
    return 0
}

// ASSERT: regex-2 = Apply\(@_CN7default3gooHv[,)]
// ASSERT: regex-1 = Apply\(@_CN7default3hooHv[,)]
// ASSERT: regex-2 = Apply\(@__sanitizer_cov_trace_const_cmp8[,)]
// ASSERT: regex-begin Func @_CN7default3foo
// ASSERT: regex-after %(?P<left0>\d+): Int64 = Apply\(@_CN7default3gooHv\)
// ASSERT: regex-after %(?P<right0>\d+): Int64 = Apply\(@_CN7default3hooHv\)
// ASSERT: regex-after %(?P<lc0>\d+): UInt64 = NumericCast\(%(?P=left0)\)
// ASSERT: regex-after %(?P<rc0>\d+): UInt64 = NumericCast\(%(?P=right0)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp8, %(?P=lc0), %(?P=rc0)\)
// ASSERT: regex-after Bool = Equal\(%(?P=left0), %(?P=right0)\)
// ASSERT: regex-after %(?P<left1>\d+): Int64 = Apply\(@_CN7default3gooHv\)
// ASSERT: regex-after %(?P<right1>\d+): Int64 = Constant\(0i\)
// ASSERT: regex-after %(?P<lc1>\d+): UInt64 = NumericCast\(%(?P=left1)\)
// ASSERT: regex-after %(?P<rc1>\d+): UInt64 = NumericCast\(%(?P=right1)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp8, %(?P=lc1), %(?P=rc1)\)
// ASSERT: regex-after Bool = Equal\(%(?P=left1), %(?P=right1)\)
