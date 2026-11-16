/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — --disable-reflection 元数据剥离语义 — IfuncsStripped
*- @TestCaseType: 功能测试
*- @Design Description: 场景矩阵：IfuncsStripped（工具链通道轴）
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
// DEPENDENCE: dut
// EXEC: %compiler --disable-reflection %cmp_opt %compile_lib_opt -p dut
// EXEC: %compiler --disable-reflection %cmp_opt %f -L . -ldut -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import dut.*
@Test
class TestDisableReflect {
    @TestCase
    func testCase0(): Unit {
        @Expect(dfooIfuncs(), 0i64)
    }

}

