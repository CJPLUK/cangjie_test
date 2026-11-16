// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-compares -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

public func step1(): Bool {
    println("enter step1")

    if (step2() == 0) {
        println("exit step1: AAA")
    }

    println("exit step1: BBB")
    return false
}

func step2(): Int32 {
    println("enter step2")
    println("exit step2")
    return 0
}

main() {
    step1()
    return 0
}

// ASSERT: regex-1 = Apply\(@_CN7default5step2Hv[,)]
// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_const_cmp4[,)]
// ASSERT: regex-begin Func @_CN7default5step1
// ASSERT: regex-after %(?P<result>\d+): Int32 = Apply\(@_CN7default5step2Hv\)
// ASSERT: regex-after %(?P<zero>\d+): Int32 = Constant\(0i\)
// ASSERT: regex-after %(?P<lhs>\d+): UInt32 = NumericCast\(%(?P=result)\)
// ASSERT: regex-after %(?P<rhs>\d+): UInt32 = NumericCast\(%(?P=zero)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp4, %(?P=lhs), %(?P=rhs)\)
// ASSERT: regex-after %(?P<equal>\d+): Bool = Equal\(%(?P=result), %(?P=zero)\)
// ASSERT: regex-after Branch\(%(?P=equal), #\d+, #\d+\)
