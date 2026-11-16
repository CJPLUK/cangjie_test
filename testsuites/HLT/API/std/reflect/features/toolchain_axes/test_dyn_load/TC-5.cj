/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-5
*- @TestCaseName: std.reflect — PackageInfo.load 正路径与 loaded 包下钻 — LoadedTypeGetInterface
*- @TestCaseType: 功能测试
*- @Design Description: 场景矩阵：LoadedTypeGetInterface（工具链通道轴）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测 dylib/静态库已由 EXEC 管线预生成
*- @Brief: 描述测试步骤
*   -#按场景构造 load/反射调用
*   -#以 dlutils/dut oracle 断言消息文本或成功结果
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，消息文本与预期契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: dlutils demo dlmod_b dlmod_c
// EXEC: %compiler %cmp_opt %compile_lib_opt -p dlutils
// EXEC: cd demo && %compiler %compilation_options %extra_options %lto_options %sanitizer_options %mock_options %optimization_options %debug_options --dy-std %compile_dylib_opt mod.cj -o liba.%test_suffix
// EXEC: cd dlmod_b && %compiler %compilation_options %extra_options %lto_options %sanitizer_options %mock_options %optimization_options %debug_options --dy-std %compile_dylib_opt mod.cj -o libb.%test_suffix
// EXEC: cd dlmod_c && %compiler %compilation_options %extra_options %lto_options %sanitizer_options %mock_options %optimization_options %debug_options --dy-std %compile_dylib_opt mod.cj -o libc.%test_suffix
// EXEC: %compiler %cmp_opt --dy-std %f -L . -ldlutils -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import std.env.*
import dlutils.*
@Test
class TestDynLoad {
    @TestCase
    func testCase0(): Unit {
        @Expect(dlPkgTypeGet("./dlmod_b/libb", "aa.bb.cc.dd.test.I0"), "OK:I0|aa.bb.cc.dd.test.I0")
    }

}

