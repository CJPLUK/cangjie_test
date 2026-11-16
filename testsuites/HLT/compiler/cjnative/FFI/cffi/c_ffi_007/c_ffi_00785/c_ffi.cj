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

foreign func free(cp: CPointer<Int8>): Unit

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
    var cStr1 = unsafe { LibC.mallocCString(LIB_NAME) }
    var cStr2 = unsafe { LibC.mallocCString("getCPointer") }
    var handle = openLib(cStr1)
    if (handle.isNull()) {
        return 1
    }
    var ptr = getSym(handle, cStr2)
    if (ptr.isNull()) {
        return 2
    }
    var foo = CFunc<() -> CPointer<UInt32>>(ptr)
    var res = foo()
    var b = res.read(0) == 0 && res.read(1) == 2 && res.read(2) == 4294967295

    free(CPointer<Int8>(res))
    LibC.free(cStr1)
    LibC.free(cStr2)
    closeLib(handle)

    if (b) {
        return 0
    } else {
        return 3
    }
}
