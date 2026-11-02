// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-inline-8bit-counters --sanitizer-coverage-pc-table -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

@FastNative
foreign func ShowCounter(): Unit

var i = 0

unsafe main() {
    api1()
    api1()
    api1()
    api2()
    api2()
    api2()
    api2()
    api2()
    ShowCounter()
    return 0
}

public func api1(): Int32 {
    return 0
}

public func api2(): Int32 {
    if (i == 0) {
        return 1
    } else {
        return 0
    }
}

// ASSERT: regex-5 = Intrinsic\(writePointer<UInt8>
// ASSERT: regex-1 = Apply\(@__cj_sancov_pcs_init[,)]
// ASSERT: regex-begin Func @\S*0\.pc_tableHv
// ASSERT: regex-after %(?P<count>\d+): Int64 = Constant\(5i\)
// ASSERT: regex-after %(?P<package>\d+): Struct-\S+ = Constant\("default"\)
// ASSERT: regex-after %(?P<packptr>\d+): CString = Apply\(.*mallocCString\w*, %(?P=package)\)
// ASSERT: regex-after %(?P<name0>\d+): Struct-\S+ = Constant\("main"\)
// ASSERT: regex-after %(?P<nptr0>\d+): CString = Apply\(.*mallocCString\w*, %(?P=name0)\)
// ASSERT: regex-after %(?P<file0>\d+): Struct-\S+ = Constant\("[^"]*traceInlinePcTable03\.cj"\)
// ASSERT: regex-after %(?P<fptr0>\d+): CString = Apply\(.*mallocCString\w*, %(?P=file0)\)
// ASSERT: regex-after %(?P<line0>\d+): UInt64 = Constant\([1-9]\d*u\)
// ASSERT: regex-after %(?P<name1>\d+): Struct-\S+ = Constant\("api1"\)
// ASSERT: regex-after %(?P<nptr1>\d+): CString = Apply\(.*mallocCString\w*, %(?P=name1)\)
// ASSERT: regex-after %(?P<file1>\d+): Struct-\S+ = Constant\("[^"]*traceInlinePcTable03\.cj"\)
// ASSERT: regex-after %(?P<fptr1>\d+): CString = Apply\(.*mallocCString\w*, %(?P=file1)\)
// ASSERT: regex-after %(?P<line1>\d+): UInt64 = Constant\([1-9]\d*u\)
// ASSERT: regex-after %(?P<name2>\d+): Struct-\S+ = Constant\("api2"\)
// ASSERT: regex-after %(?P<nptr2>\d+): CString = Apply\(.*mallocCString\w*, %(?P=name2)\)
// ASSERT: regex-after %(?P<file2>\d+): Struct-\S+ = Constant\("[^"]*traceInlinePcTable03\.cj"\)
// ASSERT: regex-after %(?P<fptr2>\d+): CString = Apply\(.*mallocCString\w*, %(?P=file2)\)
// ASSERT: regex-after %(?P<line2>\d+): UInt64 = Constant\([1-9]\d*u\)
// ASSERT: regex-after %(?P<name3>\d+): Struct-\S+ = Constant\("api2"\)
// ASSERT: regex-after %(?P<nptr3>\d+): CString = Apply\(.*mallocCString\w*, %(?P=name3)\)
// ASSERT: regex-after %(?P<file3>\d+): Struct-\S+ = Constant\("[^"]*traceInlinePcTable03\.cj"\)
// ASSERT: regex-after %(?P<fptr3>\d+): CString = Apply\(.*mallocCString\w*, %(?P=file3)\)
// ASSERT: regex-after %(?P<line3>\d+): UInt64 = Constant\([1-9]\d*u\)
// ASSERT: regex-after %(?P<name4>\d+): Struct-\S+ = Constant\("api2"\)
// ASSERT: regex-after %(?P<nptr4>\d+): CString = Apply\(.*mallocCString\w*, %(?P=name4)\)
// ASSERT: regex-after %(?P<file4>\d+): Struct-\S+ = Constant\("[^"]*traceInlinePcTable03\.cj"\)
// ASSERT: regex-after %(?P<fptr4>\d+): CString = Apply\(.*mallocCString\w*, %(?P=file4)\)
// ASSERT: regex-after %(?P<line4>\d+): UInt64 = Constant\([1-9]\d*u\)
// ASSERT: regex-after %(?P<namesarray>\d+): RawArray<CString>& = RawArrayAllocate\(CString, %(?P=count)\)
// ASSERT: regex-after Unit = RawArrayLiteralInit\(%(?P=namesarray), %(?P=nptr0), %(?P=nptr1), %(?P=nptr2), %(?P=nptr3), %(?P=nptr4)\)
// ASSERT: regex-after %(?P<namesptr>\d+): CPointer<CString> = Intrinsic\(acquireRawData<CString>, %(?P=namesarray)\)
// ASSERT: regex-after %(?P<filesarray>\d+): RawArray<CString>& = RawArrayAllocate\(CString, %(?P=count)\)
// ASSERT: regex-after Unit = RawArrayLiteralInit\(%(?P=filesarray), %(?P=fptr0), %(?P=fptr1), %(?P=fptr2), %(?P=fptr3), %(?P=fptr4)\)
// ASSERT: regex-after %(?P<filesptr>\d+): CPointer<CString> = Intrinsic\(acquireRawData<CString>, %(?P=filesarray)\)
// ASSERT: regex-after %(?P<linesarray>\d+): RawArray<UInt64>& = RawArrayAllocate\(UInt64, %(?P=count)\)
// ASSERT: regex-after Unit = RawArrayLiteralInit\(%(?P=linesarray), %(?P=line0), %(?P=line1), %(?P=line2), %(?P=line3), %(?P=line4)\)
// ASSERT: regex-after %(?P<linesptr>\d+): CPointer<UInt64> = Intrinsic\(acquireRawData<UInt64>, %(?P=linesarray)\)
// ASSERT: regex-after %(?P<usize>\d+): UInt64 = NumericCast\(%(?P=count)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sancov_pcs_init, %(?P=packptr), %(?P=usize), %(?P=namesptr), %(?P=filesptr), %(?P=linesptr)\)
