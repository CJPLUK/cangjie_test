// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Runtime hook arguments are also checked by traceStringCmpIndexOfRuntime.cj.
// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-memcmp -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt "Func @_CN7default6<main>Hv" | compare %f

main(): Int64 {
    let str = "test"
    var res5: Int64 = str.indexOf("12") ?? -1
    var res1: Int64 = str.indexOf(12) ?? -1
    0
}

// ASSERT: regex-1 = Apply\(@__cj_sanitizer_weak_hook_memcmp,
// ASSERT: regex-1 = Apply\(.*->@_CNat6String7indexOfHRNatY0_E,
// ASSERT: regex-1 = Apply\(.*->@_CNat6String7indexOfHh,
// ASSERT: regex-begin Func @_CN7default6<main>Hv
// ASSERT: regex-after %(?P<string>\d+): Struct-_CNat6StringE = Constant\("test"\)
// ASSERT: regex-after %(?P<needle>\d+): Struct-_CNat6StringE = Constant\("12"\)
// ASSERT: regex-after %(?P<stringarray>\d+): RawArray<UInt8>& = Field\(%(?P=string), 0\)
// ASSERT: regex-after %(?P<stringoffset>\d+): UInt32 = Field\(%(?P=string), 1\)
// ASSERT: regex-after %(?P<stringcast>\d+): Int64 = NumericCast\(%(?P=stringoffset)\)
// ASSERT: regex-after %(?P<stringraw>\d+): CPointer<UInt8> = Intrinsic\(acquireRawData<UInt8>, %(?P=stringarray)\)
// ASSERT: regex-after %(?P<stringpoint>\d+): CPointer<UInt8> = Intrinsic\(addPointer<UInt8>, %(?P=stringraw), %(?P=stringcast)\)
// ASSERT: regex-after %(?P<needlearray>\d+): RawArray<UInt8>& = Field\(%(?P=needle), 0\)
// ASSERT: regex-after %(?P<needleoffset>\d+): UInt32 = Field\(%(?P=needle), 1\)
// ASSERT: regex-after %(?P<needlecast>\d+): Int64 = NumericCast\(%(?P=needleoffset)\)
// ASSERT: regex-after %(?P<needleraw>\d+): CPointer<UInt8> = Intrinsic\(acquireRawData<UInt8>, %(?P=needlearray)\)
// ASSERT: regex-after %(?P<needlepoint>\d+): CPointer<UInt8> = Intrinsic\(addPointer<UInt8>, %(?P=needleraw), %(?P=needlecast)\)
// ASSERT: regex-after %(?P<stringvoid>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=stringpoint)\)
// ASSERT: regex-after %(?P<needlevoid>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=needlepoint)\)
// ASSERT: regex-after %(?P<length>\d+): UInt32 = Field\(%(?P=string), 2\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=stringvoid), %(?P=needlevoid), %(?P=length)\)
// ASSERT: regex-after = Apply\(.*->@_CNat6String7indexOfHRNatY0_E, %(?P=string), %(?P=needle)\)
// ASSERT: regex-after %(?P<byte>\d+): UInt8 = Constant\(12u\)
// ASSERT: regex-after = Apply\(.*->@_CNat6String7indexOfHh, %(?P=string), %(?P=byte)\)
