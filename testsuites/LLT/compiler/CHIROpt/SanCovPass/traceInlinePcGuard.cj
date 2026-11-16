// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-level=1 --sanitizer-coverage-trace-pc-guard -Woff all %f -o sancov-function.out
// EXEC: %python pick_defination.py sancov-function_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f --assert_flag=ASSERT_FUNCTION
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-level=2 --sanitizer-coverage-trace-pc-guard -Woff all %f -o sancov-block.out
// EXEC: %python pick_defination.py sancov-block_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

foreign func ShowUInt32Array(): Unit

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

func D(n: Int32): Int64 {
    var t: Int64 = 0
    match (n) {
        case 1 => t = 1
        case 2 => t = 2
        case _ => t = 3
    }
    return t
}

func f2(): Int64 {
    var i: Int32 = 0
    var t: Int64 = f1(1, 1, 1, 1)
    while (i < 3) {
        t += 1
        i += 1
        break;
    }
    return t
}

main() {
    println(" ----- before -----")
    unsafe { ShowUInt32Array() };
    D(1)
    f1(1, 1, 1, 1)
    f2()
    println(" ----- after -----")
    unsafe { ShowUInt32Array() };
    0
}

// ASSERT_FUNCTION: regex-4 = Intrinsic\(addPointer<UInt32>
// ASSERT_FUNCTION: regex-1 = Apply\(@__cj_sancov_pc_guard_ctor[,)]
// ASSERT_FUNCTION: regex-4 = Apply\(@__sanitizer_cov_trace_pc_guard[,)]
// ASSERT_FUNCTION: regex-begin Func @\S*0\.sancov\$_pc_guardHv
// ASSERT_FUNCTION: regex-after %(?P<size>\d+): UInt64 = Constant\(4u\)
// ASSERT_FUNCTION: regex-after %(?P<storage>\d+): CPointer<UInt32> = Apply\(@__cj_sancov_pc_guard_ctor, %(?P=size)\)
// ASSERT_FUNCTION: regex-after Unit = Store\(%(?P=storage), @sancov\$_pc_guard\)
// ASSERT_FUNCTION: regex-begin Func @_CN7default6<main>
// ASSERT_FUNCTION: regex-after %(?P<counter>\d+): CPointer<UInt32> = Load\(@sancov\$_pc_guard\)
// ASSERT_FUNCTION: regex-after %(?P<offset>\d+): Int64 = Constant\(\d+i\)
// ASSERT_FUNCTION: regex-after %(?P<point>\d+): CPointer<UInt32> = Intrinsic\(addPointer<UInt32>, %(?P=counter), %(?P=offset)\)
// ASSERT_FUNCTION: regex-after Unit = Apply\(@__sanitizer_cov_trace_pc_guard, %(?P=point)\)

// ASSERT: regex-16 = Intrinsic\(addPointer<UInt32>
// ASSERT: regex-1 = Apply\(@__cj_sancov_pc_guard_ctor[,)]
// ASSERT: regex-16 = Apply\(@__sanitizer_cov_trace_pc_guard[,)]
// ASSERT: regex-begin Func @\S*0\.sancov\$_pc_guardHv
// ASSERT: regex-after %(?P<size>\d+): UInt64 = Constant\(16u\)
// ASSERT: regex-after %(?P<storage>\d+): CPointer<UInt32> = Apply\(@__cj_sancov_pc_guard_ctor, %(?P=size)\)
// ASSERT: regex-after Unit = Store\(%(?P=storage), @sancov\$_pc_guard\)
// ASSERT: regex-begin Func @_CN7default6<main>
// ASSERT: regex-after %(?P<counter>\d+): CPointer<UInt32> = Load\(@sancov\$_pc_guard\)
// ASSERT: regex-after %(?P<offset>\d+): Int64 = Constant\(\d+i\)
// ASSERT: regex-after %(?P<point>\d+): CPointer<UInt32> = Intrinsic\(addPointer<UInt32>, %(?P=counter), %(?P=offset)\)
// ASSERT: regex-after Unit = Apply\(@__sanitizer_cov_trace_pc_guard, %(?P=point)\)
