// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-inline-8bit-counters --sanitizer-coverage-trace-pc-guard -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

main() {
    println(12)
    0
}

// ASSERT: regex-1 = Intrinsic\(readPointer<UInt8>
// ASSERT: regex-1 = Apply\(@__cj_sancov_8bit_counters_ctor[,)]
// ASSERT: regex-1 = Intrinsic\(writePointer<UInt8>
// ASSERT: regex-1 = Apply\(@__sanitizer_cov_trace_pc_guard[,)]
// ASSERT: regex-1 = Apply\(@__cj_sancov_pc_guard_ctor[,)]
// ASSERT: regex-begin Func @\S*0\.sancov\$_8bit_countersHv
// ASSERT: regex-after %(?P<size>\d+): UInt64 = Constant\(1u\)
// ASSERT: regex-after %(?P<storage>\d+): CPointer<UInt8> = Apply\(@__cj_sancov_8bit_counters_ctor, %(?P=size)\)
// ASSERT: regex-after Unit = Store\(%(?P=storage), @sancov\$_8bit_counters\)
// ASSERT: regex-begin Func @_CN7default6<main>
// ASSERT: regex-after %(?P<counter>\d+): CPointer<UInt8> = Load\(@sancov\$_8bit_counters\)
// ASSERT: regex-after %(?P<offset>\d+): Int64 = Constant\(\d+i\)
// ASSERT: regex-after %(?P<old>\d+): UInt8 = Intrinsic\(readPointer<UInt8>, %(?P=counter), %(?P=offset)\)
// ASSERT: regex-after %(?P<one>\d+): UInt8 = Constant\(1u\)
// ASSERT: regex-after %(?P<new>\d+): UInt8 = Add\(%(?P=old), %(?P=one)\).*Overflow: WRAPPING
// ASSERT: regex-after Unit = Intrinsic\(writePointer<UInt8>, %(?P=counter), %(?P=offset), %(?P=new)\)
// ASSERT: regex-begin Func @_CN7default6<main>
// ASSERT: regex-after %(?P<guard>\d+): CPointer<UInt32> = Load\(@sancov\$_pc_guard\)
// ASSERT: regex-after %(?P<guardoffset>\d+): Int64 = Constant\(0i\)
// ASSERT: regex-after %(?P<guardptr>\d+): CPointer<UInt32> = Intrinsic\(addPointer<UInt32>, %(?P=guard), %(?P=guardoffset)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_pc_guard, %(?P=guardptr)\)
