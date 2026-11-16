// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug %enableO2 --sanitizer-coverage-level=1 --sanitizer-coverage-inline-8bit-counters -Woff all %f -o sancov-function.out
// EXEC: %python pick_defination.py sancov-function_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f --assert_flag=ASSERT_FUNCTION
// EXEC: %frontendCompiler %dumpCHIRDebug %enableO2 --sanitizer-coverage-level=2 --sanitizer-coverage-inline-8bit-counters -Woff all %f -o sancov-block.out
// EXEC: %python pick_defination.py sancov-block_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

func D(n: Int32): Int64 {
    var t: Int64 = 0
    match (n) {
        case 1 => t = 1
        case 2 => t = 2
        case _ => t = 3
    }
    return t
}

func f2(): Int32 {
    var i: Int32 = 0
    while (i < 5) {
        i += 1
    }
    return i
}

main() {
    D(1)
    try {
        f2()
    } catch (_) {
        println("catch an exception!")
    }
    0
}

// ASSERT_FUNCTION: regex-2 = Intrinsic\(readPointer<UInt8>
// ASSERT_FUNCTION: regex-1 = Apply\(@__cj_sancov_8bit_counters_ctor[,)]
// ASSERT_FUNCTION: regex-2 = Intrinsic\(writePointer<UInt8>
// ASSERT_FUNCTION: regex-begin Func @\S*0\.sancov\$_8bit_countersHv
// ASSERT_FUNCTION: regex-after %(?P<size>\d+): UInt64 = Constant\(2u\)
// ASSERT_FUNCTION: regex-after %(?P<storage>\d+): CPointer<UInt8> = Apply\(@__cj_sancov_8bit_counters_ctor, %(?P=size)\)
// ASSERT_FUNCTION: regex-after Unit = Store\(%(?P=storage), @sancov\$_8bit_counters\)
// ASSERT_FUNCTION: regex-begin Func @_CN7default6<main>
// ASSERT_FUNCTION: regex-after %(?P<counter>\d+): CPointer<UInt8> = Load\(@sancov\$_8bit_counters\)
// ASSERT_FUNCTION: regex-after %(?P<offset>\d+): Int64 = Constant\(\d+i\)
// ASSERT_FUNCTION: regex-after %(?P<old>\d+): UInt8 = Intrinsic\(readPointer<UInt8>, %(?P=counter), %(?P=offset)\)
// ASSERT_FUNCTION: regex-after %(?P<one>\d+): UInt8 = Constant\(1u\)
// ASSERT_FUNCTION: regex-after %(?P<new>\d+): UInt8 = Add\(%(?P=old), %(?P=one)\).*Overflow: WRAPPING
// ASSERT_FUNCTION: regex-after Unit = Intrinsic\(writePointer<UInt8>, %(?P=counter), %(?P=offset), %(?P=new)\)

// ASSERT: regex-9 = Intrinsic\(readPointer<UInt8>
// ASSERT: regex-1 = Apply\(@__cj_sancov_8bit_counters_ctor[,)]
// ASSERT: regex-9 = Intrinsic\(writePointer<UInt8>
// ASSERT: regex-begin Func @\S*0\.sancov\$_8bit_countersHv
// ASSERT: regex-after %(?P<size>\d+): UInt64 = Constant\(9u\)
// ASSERT: regex-after %(?P<storage>\d+): CPointer<UInt8> = Apply\(@__cj_sancov_8bit_counters_ctor, %(?P=size)\)
// ASSERT: regex-after Unit = Store\(%(?P=storage), @sancov\$_8bit_counters\)
// ASSERT: regex-begin Func @_CN7default6<main>
// ASSERT: regex-after %(?P<counter>\d+): CPointer<UInt8> = Load\(@sancov\$_8bit_counters\)
// ASSERT: regex-after %(?P<offset>\d+): Int64 = Constant\(\d+i\)
// ASSERT: regex-after %(?P<old>\d+): UInt8 = Intrinsic\(readPointer<UInt8>, %(?P=counter), %(?P=offset)\)
// ASSERT: regex-after %(?P<one>\d+): UInt8 = Constant\(1u\)
// ASSERT: regex-after %(?P<new>\d+): UInt8 = Add\(%(?P=old), %(?P=one)\).*Overflow: WRAPPING
// ASSERT: regex-after Unit = Intrinsic\(writePointer<UInt8>, %(?P=counter), %(?P=offset), %(?P=new)\)
