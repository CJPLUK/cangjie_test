// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug --sanitizer-coverage-trace-compares -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

foreign func ShowSwitchArray(): Unit

func f1(t1: Int8, t2: Int16, t4: Int32, t8: Int64): Int64 {
    if (t1 != 0) {
        if (t2 != 0) {
            if (t4 != 0) {
                if (t8 != 0) {
                    return Int64(t1) & Int64(t2) & Int64(t4) & t8
                }
            }
        }
    }
    return 1
}

func fD(n: Int64): Int64 {
    var t: Int64 = 0
    match (n) {
        case 1 => t = 1
        case 2 => t = 2
        case 3 => t = 3
        case 4 => t = 4
        case 5 => t = 5
        case _ => t = 6
    }
    println(t)
    return t
}

main() {
    var a: Int64 = 1
    var b = fD(a)
    f1(1, 1, 1, 1)
    0
}

// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_const_cmp1[,)]
// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_const_cmp2[,)]
// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_const_cmp4[,)]
// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_const_cmp8[,)]
// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_switch[,)]
// ASSERT: regex-begin Func @_CN7default2f1
// ASSERT: regex-after %(?P<t1>\d+)\[t1\]: Int8
// ASSERT: regex-after %(?P<t2>\d+)\[t2\]: Int16
// ASSERT: regex-after %(?P<t4>\d+)\[t4\]: Int32
// ASSERT: regex-after %(?P<t8>\d+)\[t8\]: Int64
// ASSERT: regex-after %(?P<zero0>\d+): Int8 = Constant\(0i\)
// ASSERT: regex-after %(?P<lhs0>\d+): UInt8 = NumericCast\(%(?P=t1)\)
// ASSERT: regex-after %(?P<rhs0>\d+): UInt8 = NumericCast\(%(?P=zero0)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp1, %(?P=lhs0), %(?P=rhs0)\)
// ASSERT: regex-after Bool = NotEqual\(%(?P=t1), %(?P=zero0)\)
// ASSERT: regex-after %(?P<zero1>\d+): Int16 = Constant\(0i\)
// ASSERT: regex-after %(?P<lhs1>\d+): UInt16 = NumericCast\(%(?P=t2)\)
// ASSERT: regex-after %(?P<rhs1>\d+): UInt16 = NumericCast\(%(?P=zero1)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp2, %(?P=lhs1), %(?P=rhs1)\)
// ASSERT: regex-after Bool = NotEqual\(%(?P=t2), %(?P=zero1)\)
// ASSERT: regex-after %(?P<zero2>\d+): Int32 = Constant\(0i\)
// ASSERT: regex-after %(?P<lhs2>\d+): UInt32 = NumericCast\(%(?P=t4)\)
// ASSERT: regex-after %(?P<rhs2>\d+): UInt32 = NumericCast\(%(?P=zero2)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp4, %(?P=lhs2), %(?P=rhs2)\)
// ASSERT: regex-after Bool = NotEqual\(%(?P=t4), %(?P=zero2)\)
// ASSERT: regex-after %(?P<zero3>\d+): Int64 = Constant\(0i\)
// ASSERT: regex-after %(?P<lhs3>\d+): UInt64 = NumericCast\(%(?P=t8)\)
// ASSERT: regex-after %(?P<rhs3>\d+): UInt64 = NumericCast\(%(?P=zero3)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_const_cmp8, %(?P=lhs3), %(?P=rhs3)\)
// ASSERT: regex-after Bool = NotEqual\(%(?P=t8), %(?P=zero3)\)
// ASSERT: regex-begin Func @_CN7default2fD
// ASSERT: regex-after %(?P<switch>\d+)\[n\]: Int64
// ASSERT: regex-after %(?P<switchval>\d+): UInt64 = NumericCast\(%(?P=switch)\)
// ASSERT: regex-after %(?P<cases>\d+): UInt64 = Constant\(5u\)
// ASSERT: regex-after %(?P<bits>\d+): UInt64 = Constant\(64u\)
// ASSERT: regex-after %(?P<case1>\d+): UInt64 = Constant\(1u\)
// ASSERT: regex-after %(?P<case2>\d+): UInt64 = Constant\(2u\)
// ASSERT: regex-after %(?P<case3>\d+): UInt64 = Constant\(3u\)
// ASSERT: regex-after %(?P<case4>\d+): UInt64 = Constant\(4u\)
// ASSERT: regex-after %(?P<case5>\d+): UInt64 = Constant\(5u\)
// ASSERT: regex-after %(?P<arraysize>\d+): Int64 = Constant\(7i\)
// ASSERT: regex-after %(?P<table>\d+): RawArray<UInt64>& = RawArrayAllocate\(UInt64, %(?P=arraysize)\)
// ASSERT: regex-after %(?P<tableptr>\d+): CPointer<UInt64> = Intrinsic\(acquireRawData<UInt64>, %(?P=table)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_switch, %(?P=switchval), %(?P=tableptr)\)
// ASSERT: regex-after MultiBranch\(%(?P=switchval), #\d+, \[1, #\d+\], \[2, #\d+\], \[3, #\d+\], \[4, #\d+\], \[5, #\d+\]\)
