// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package tmp_test
import my_test1.*
import my_test2.*

// LEVEL: 1

// DEPENDENCE: my_test1.cj my_test2.cj
// (target_android)EXEC: %compiler %compilation_options %extra_options %sanitizer_options %mock_options %optimization_options %debug_options %linkage_options %compile_lib_opt --experimental --lto=full my_test2.cj --lto-staticlib-format=native -o libmy_test2.a
// (target_android)EXEC: %compiler  --lto-keep-pkg-visibility="my_test1,my_test3" %compilation_options %extra_options %sanitizer_options %mock_options %optimization_options %debug_options %linkage_options %compile_lib_opt --experimental --lto=full my_test1.cj libmy_test2.a -o libmy_test1.a 
// (target_android)EXEC-1: nm libmy_test1.a | grep -E "T.*(foo|fxx)" 
// (target_android)EXEC: nm libmy_test1.a | grep -E "T.*(hw)" 
// (target_android)EXEC: %compiler %compilation_options %extra_options %sanitizer_options %mock_options %optimization_options %debug_options %linkage_options %f libmy_test1.a libmy_test2.a -o %output
// (target_android)RUN-EXEC: %run %run_opt %output %run_args

main(): Int64 {
    hw()
    return 0
}