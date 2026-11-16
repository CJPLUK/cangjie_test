/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL:2
// DEPENDENCE: %n.c
// EXEC: %clang %clang_opt %n.c -o libc_ffi.%cffi_suffix
// (host_win & target_win) EXEC: %compiler %cmp_opt c_ffi.cj -o %output
// (not (host_win & target_win)) EXEC: %compiler %cmp_opt c_ffi.cj -l dl -o %output

// RUN-EXEC: %run %run_opt %output %run_args

@When[os == "macOS"]
let LIB_NAME = "libc_ffi.dylib"
@When[os == "Windows"]
let LIB_NAME = "libc_ffi.dll"
@When[os != "macOS" && os != "Windows"]
let LIB_NAME = "libc_ffi.so"

@C
struct MyRecord {
    public MyRecord(var a: Int64) {}
}

foreign func AllocCStruct(): CPointer<MyRecord>

foreign func GetMaxFuncPtr(): CFunc<(CPointer<MyRecord>) -> (CPointer<MyRecord>)>

@When[os == "Windows"]
foreign func LoadLibraryA(filename: CString): CPointer<Int8>

@When[os != "Windows"]
foreign func dlopen(filename: CString, flags: Int32): CPointer<Int8>

@When[os == "Windows"]
foreign func GetProcAddress(handle: CPointer<Int8>, symbol: CString): CPointer<Int8>

@When[os != "Windows"]
foreign func dlsym(handle: CPointer<Int8>, symbol: CString): CPointer<Int8>

@When[os == "Windows"]
foreign func FreeLibrary(handle: CPointer<Int8>): Int32

@When[os != "Windows"]
foreign func dlclose(handle: CPointer<Int8>): Int32

@When[os == "Windows"]
unsafe func openLib(name: CString): CPointer<Int8> {
    return LoadLibraryA(name)
}

@When[os != "Windows"]
unsafe func openLib(name: CString): CPointer<Int8> {
    return dlopen(name, 1)
}

@When[os == "Windows"]
unsafe func getSym(handle: CPointer<Int8>, name: CString): CPointer<Int8> {
    return GetProcAddress(handle, name)
}

@When[os != "Windows"]
unsafe func getSym(handle: CPointer<Int8>, name: CString): CPointer<Int8> {
    return dlsym(handle, name)
}

@When[os == "Windows"]
unsafe func closeLib(handle: CPointer<Int8>): Int32 {
    return FreeLibrary(handle)
}

@When[os != "Windows"]
unsafe func closeLib(handle: CPointer<Int8>): Int32 {
    return dlclose(handle)
}

unsafe main(): Int64 {
    var handle = openLib(unsafe { LibC.mallocCString(LIB_NAME) })
    if (handle.isNull()) {
        return 1
    }
    var cfunc = getSym(handle, unsafe { LibC.mallocCString("GetMaxFuncPtr") })
    if (cfunc.isNull()) {
        return 2
    }
    var res = CPointer<Int32>(cfunc)
    if (res.isNull()) {
        return 3
    }
    return 0
}
