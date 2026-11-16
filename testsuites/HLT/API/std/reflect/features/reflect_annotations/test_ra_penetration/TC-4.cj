/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-4
*- @TestCaseName: std.reflect — 注解三级穿透 × 类型形状（探针锚定 1.3.0-alpha.02） — StructVarLevel
*- @TestCaseType: 功能测试
*- @Design Description: 场景矩阵：StructVarLevel（注解穿透轴）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#rann/ranno 静态库已由 EXEC 管线预编译
*- @Brief: 描述测试步骤
*   -#按场景构造 std.reflect 注解调用
*   -#以 ranno oracle 断言消息文本或成功结果
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，消息文本与消息契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: rann ranno
// EXEC: %compiler %cmp_opt %compile_lib_opt -p rann
// EXEC: %compiler %cmp_opt %compile_lib_opt -p ranno -L . -lrann
// EXEC: %compiler %cmp_opt %f -L . -lrann -lranno -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import rann.*
import ranno.*
@Test
class TestRaPenetration {
    @TestCase
    func testCase0(): Unit {
        @Expect(raStructVar(), "OK:1|1")
    }

}

