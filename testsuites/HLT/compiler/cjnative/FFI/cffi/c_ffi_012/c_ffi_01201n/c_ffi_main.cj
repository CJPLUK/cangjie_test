/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL:2
// DEPENDENCE: pkg cfg.json cfg-main.json c_ffi.c
// EXEC: %clang %clang_opt c_ffi.c -o libc_ffi.%test_suffix
// EXEC: %sed %sed_opt "s!cangjieCFFI_path!%cstring_cjo!g" cfg.json
// EXEC: %sed %sed_opt "s!cangjieCFFI_path!%cstring_cjo!g" cfg-main.json
// EXEC: %compiler %cmp_opt %pkg_compile pkg/pkg.cj -o libpkg.%test_suffix
// ERRCHECK: %compiler %cmp_opt %f %pkg_link -o %output

import pkg

unsafe main(): Int64 {
    var result: Int8 = newtestfunc(1, 2)
    if (result == 3) {
        print("pass\n")
    }
    return 0
}
// ASSERT: scan sema_undeclared_identifier
