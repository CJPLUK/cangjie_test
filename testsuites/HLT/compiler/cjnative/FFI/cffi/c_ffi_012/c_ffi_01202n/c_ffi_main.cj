/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL:2
// DEPENDENCE: pkg c_ffi.c

// 1. build c library.
// (host_mac) EXEC: %clang %clang_opt c_ffi.c -o libc_ffi.%test_suffix
// (host_linux) EXEC: %clang %clang_opt c_ffi.c -o libc_ffi.%test_suffix
// (host_win) EXEC: %clang %clang_opt c_ffi.c -o libc_ffi.%test_suffix

// 2. successfully build pkg library, linking c library.
// (host_mac & target_android) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix
// (host_mac & target_ohos) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix
// (host_mac & (target_ios | target_ios_simulator)) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix
// (host_linux & target_android) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix
// (host_linux & target_linux) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix
// (host_win & target_android) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix
// (host_win & target_ohos) EXEC: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix

// 2. fail to build pkg library, linking c library.
// (host_mac & target_mac) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix 2>&1 | compare %f
// (host_mac & target_mac) ASSERT: scan undefined symbol: _testfunc
// (host_win & target_win) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt -L. -lc_ffi pkg/pkg.cj -o libpkg.%test_suffix 2>&1 | compare %f
// (host_win & target_win) ASSERT: scan undefined symbol: testfunc

// 3. fail to build main executable, linking both c library & pkg library.
// (host_mac & target_ohos) EXEC-PIPE-1: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std 2>&1 | compare %f
// (host_mac & target_ohos) ASSERT: scan undefined reference due to --no-allow-shlib-undefined: testfunc
// (host_linux & target_android) EXEC-PIPE-1: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std 2>&1 | compare %f
// (host_linux & target_android) ASSERT: scan undefined reference due to --no-allow-shlib-undefined: testfunc
// (host_mac & target_android) EXEC-PIPE-1: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std 2>&1 | compare %f
// (host_mac & target_android) ASSERT: scan undefined reference due to --no-allow-shlib-undefined: testfunc
// (host_linux & target_linux) EXEC-PIPE-1: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std 2>&1 | compare %f
// (host_linux & target_linux) ASSERT: scan undefined reference to `testfunc'
// (host_win & target_android) EXEC-PIPE-1: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std 2>&1 | compare %f
// (host_win & target_android) ASSERT: scan undefined reference due to --no-allow-shlib-undefined: testfunc
// (host_win & target_ohos) EXEC-PIPE-1: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std 2>&1 | compare %f
// (host_win & target_ohos) ASSERT: scan undefined reference due to --no-allow-shlib-undefined: testfunc
// mac-ios scenario is special, because it is building a static lib, the compilation would not fail until building with XCode project.
// (host_mac & (target_ios | target_ios_simulator)) EXEC: %compiler %cmp_opt -L. -lc_ffi -lpkg %f -o %output --dy-std
// (host_mac & (target_ios | target_ios_simulator)) RUN-EXEC-PIPE-255: %run %run_opt %output %run_args 2>&1 | compare %f
// (host_mac & (target_ios | target_ios_simulator)) ASSERT: scan \"_testfunc\", referenced from:

// but in all cases, this error should not be present.
// ASSERT: regex-not no position error occurred

import pkg.*

unsafe main(): Int64 {
    var result: Int8 = newtestfunc(1, 2)
    if (result == 3) {
        print("pass\n")
    }
    return 0
}
