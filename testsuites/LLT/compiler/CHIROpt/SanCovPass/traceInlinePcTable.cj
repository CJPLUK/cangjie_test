// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-inline-8bit-counters --sanitizer-coverage-pc-table -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

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

// switch => match
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
    f1(1, 1, 1, 1)
    D(1)
    f2()
    println(" ----- after -----")
    0
}

// ASSERT: regex-16 = Intrinsic\(readPointer<UInt8>
// ASSERT: regex-1 = Apply\(@__cj_sancov_8bit_counters_ctor[,)]
// ASSERT: regex-16 = Intrinsic\(writePointer<UInt8>
// ASSERT: regex-1 = Apply\(@__cj_sancov_pcs_init[,)]
// ASSERT: regex-begin Func @\S*0\.sancov\$_8bit_countersHv
// ASSERT: regex-after %(?P<size>\d+): UInt64 = Constant\(16u\)
// ASSERT: regex-after %(?P<storage>\d+): CPointer<UInt8> = Apply\(@__cj_sancov_8bit_counters_ctor, %(?P=size)\)
// ASSERT: regex-after Unit = Store\(%(?P=storage), @sancov\$_8bit_counters\)
// ASSERT: regex-begin Func @_CN7default6<main>
// ASSERT: regex-after %(?P<counter>\d+): CPointer<UInt8> = Load\(@sancov\$_8bit_counters\)
// ASSERT: regex-after %(?P<offset>\d+): Int64 = Constant\(\d+i\)
// ASSERT: regex-after %(?P<old>\d+): UInt8 = Intrinsic\(readPointer<UInt8>, %(?P=counter), %(?P=offset)\)
// ASSERT: regex-after %(?P<one>\d+): UInt8 = Constant\(1u\)
// ASSERT: regex-after %(?P<new>\d+): UInt8 = Add\(%(?P=old), %(?P=one)\).*Overflow: WRAPPING
// ASSERT: regex-after Unit = Intrinsic\(writePointer<UInt8>, %(?P=counter), %(?P=offset), %(?P=new)\)
// ASSERT: scan 0.pc_tableHv
