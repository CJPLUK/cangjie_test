// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-memcmp -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

func f1(s1: String, s2: String, s3: String): String {
    if (s1 == "test") {
        return s1
    }
    if (s2.startsWith("te")) {
        return s2
    }
    if (s2.endsWith("st")) {
        return s2
    }
    if (s3.indexOf("te", 0) != None) {
        return s3
    }
    if (s3.replace("te", "se") == "tese") {
        return s3
    }
    if (s3.contains("te")) {
        return s3
    }
    return ""
}

main() {
    f1("test", "test", "test")
    0
}

// ASSERT: regex-7 = Apply\(@__cj_sanitizer_weak_hook_memcmp[,)]
// ASSERT: regex-begin Func @_CN7default2f1
// ASSERT: regex-after %(?P<s1>\d+)\[s1\]:
// ASSERT: regex-after %(?P<literal>\d+): Struct-\S+ = Constant\("test"\)
// ASSERT: regex-after %(?P<straarray>\d+): RawArray<UInt8>& = Field\(%(?P=s1), 0\)
// ASSERT: regex-after %(?P<straoffset>\d+): UInt32 = Field\(%(?P=s1), 1\)
// ASSERT: regex-after %(?P<stracast>\d+): Int64 = NumericCast\(%(?P=straoffset)\)
// ASSERT: regex-after %(?P<straraw>\d+): CPointer<UInt8> = Intrinsic\(acquireRawData<UInt8>, %(?P=straarray)\)
// ASSERT: regex-after %(?P<straptr>\d+): CPointer<UInt8> = Intrinsic\(addPointer<UInt8>, %(?P=straraw), %(?P=stracast)\)
// ASSERT: regex-after %(?P<strbarray>\d+): RawArray<UInt8>& = Field\(%(?P=literal), 0\)
// ASSERT: regex-after %(?P<strboffset>\d+): UInt32 = Field\(%(?P=literal), 1\)
// ASSERT: regex-after %(?P<strbcast>\d+): Int64 = NumericCast\(%(?P=strboffset)\)
// ASSERT: regex-after %(?P<strbraw>\d+): CPointer<UInt8> = Intrinsic\(acquireRawData<UInt8>, %(?P=strbarray)\)
// ASSERT: regex-after %(?P<strbptr>\d+): CPointer<UInt8> = Intrinsic\(addPointer<UInt8>, %(?P=strbraw), %(?P=strbcast)\)
// ASSERT: regex-after %(?P<strleft>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=straptr)\)
// ASSERT: regex-after %(?P<strright>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=strbptr)\)
// ASSERT: regex-after %(?P<length>\d+): UInt32 = Field\(%(?P=s1), 2\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=strleft), %(?P=strright), %(?P=length)\)
// ASSERT: regex-after Bool = Apply\(.*Stringeq\w*, %(?P=s1), %(?P=literal)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %\d+, %\d+, %\d+\)
// ASSERT: regex-after = Apply\(.*startsWith\w*,
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %\d+, %\d+, %\d+\)
// ASSERT: regex-after = Apply\(.*endsWith\w*,
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %\d+, %\d+, %\d+\)
// ASSERT: regex-after = Apply\(.*indexOf\w*,
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %\d+, %\d+, %\d+\)
// ASSERT: regex-after = Apply\(.*replace\w*,
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %\d+, %\d+, %\d+\)
// ASSERT: regex-after = Apply\(.*Stringeq\w*,
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %\d+, %\d+, %\d+\)
// ASSERT: regex-after = Apply\(.*contains\w*,
