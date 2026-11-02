// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-memcmp -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

func f2(s1: CString, s2: CString, s3: CString): CString {
    if (s1.equals(s2)) {
        return s1
    }
    if (s2.startsWith(s3)) {
        return s2
    }
    if (s1.endsWith(s3)) {
        return s1
    }
    if (s3.compare(s1) == 0) {
        return s3
    }
    if (s2.equalsLower(s3)) {
        return s3
    }
    return s1
}

main() {
    unsafe {
        let a: CString = LibC.mallocCString("east")
        let b: CString = LibC.mallocCString("west")
        let c: CString = LibC.mallocCString("noth")
        f2(a, b, c)
    }
    0
}

// ASSERT: regex-2 = Apply\(@__cj_sanitizer_weak_hook_strcmp[,)]
// ASSERT: regex-1 = Apply\(@__cj_sanitizer_weak_hook_memcmp[,)]
// ASSERT: regex-1 = Apply\(@__cj_sanitizer_weak_hook_strncmp[,)]
// ASSERT: regex-1 = Apply\(@__cj_sanitizer_weak_hook_strcasecmp[,)]
// ASSERT: regex-begin Func @_CN7default2f2
// ASSERT: regex-after %(?P<s1>\d+)\[s1\]: CString
// ASSERT: regex-after %(?P<s2>\d+)\[s2\]: CString
// ASSERT: regex-after %(?P<s3>\d+)\[s3\]: CString
// ASSERT: regex-after %(?P<cmp0a>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s1)\)
// ASSERT: regex-after %(?P<cmp0b>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s2)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_strcmp, %(?P=cmp0a), %(?P=cmp0b)\)
// ASSERT: regex-after = Apply\(CString->@\S*equals\w*, %(?P=s1), %(?P=s2)\)
// ASSERT: regex-after %(?P<cmp1a>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s2)\)
// ASSERT: regex-after %(?P<cmp1b>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s3)\)
// ASSERT: regex-after %(?P<cmp1voida>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=cmp1a)\)
// ASSERT: regex-after %(?P<cmp1voidb>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=cmp1b)\)
// ASSERT: regex-after %(?P<cmp1length>\d+): Int64 = Apply\(CString->@\S*4sizeHv, %(?P=s2)\)
// ASSERT: regex-after %(?P<cmp1size>\d+): UInt32 = NumericCast\(%(?P=cmp1length)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=cmp1voida), %(?P=cmp1voidb), %(?P=cmp1size)\)
// ASSERT: regex-after = Apply\(CString->@\S*startsWith\w*, %(?P=s2), %(?P=s3)\)
// ASSERT: regex-after %(?P<cmp2a>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s1)\)
// ASSERT: regex-after %(?P<cmp2b>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s3)\)
// ASSERT: regex-after %(?P<cmp2length>\d+): Int64 = Apply\(CString->@\S*4sizeHv, %(?P=s1)\)
// ASSERT: regex-after %(?P<cmp2size>\d+): UInt32 = NumericCast\(%(?P=cmp2length)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_strncmp, %(?P=cmp2a), %(?P=cmp2b), %(?P=cmp2size)\)
// ASSERT: regex-after = Apply\(CString->@\S*endsWith\w*, %(?P=s1), %(?P=s3)\)
// ASSERT: regex-after %(?P<cmp3a>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s3)\)
// ASSERT: regex-after %(?P<cmp3b>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s1)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_strcmp, %(?P=cmp3a), %(?P=cmp3b)\)
// ASSERT: regex-after = Apply\(CString->@\S*compare\w*, %(?P=s3), %(?P=s1)\)
// ASSERT: regex-after %(?P<cmp4a>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s2)\)
// ASSERT: regex-after %(?P<cmp4b>\d+): CPointer<UInt8> = Intrinsic\(convertCStr2Ptr, %(?P=s3)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_strcasecmp, %(?P=cmp4a), %(?P=cmp4b)\)
// ASSERT: regex-after = Apply\(CString->@\S*equalsLower\w*, %(?P=s2), %(?P=s3)\)
