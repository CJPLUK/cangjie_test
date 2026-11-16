/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-3
*- @TestCaseName: std.reflect — 成员集合组合渲染与 open/abstract 前缀契约（探针锚定 1.3.0-alpha.02） — OpenPrefix
*- @TestCaseType: 功能测试
*- @Design Description: 场景矩阵：OpenPrefix（渲染文本契约轴）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#rcont/rcon/rcor 静态库已由 EXEC 管线预编译
*- @Brief: 描述测试步骤
*   -#按场景构造 std.reflect 渲染调用
*   -#以 rcor oracle 断言渲染文本与渲染契约逐字一致
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，渲染文本与渲染契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: rcont rcon rcor
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p rcont
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p rcon -L . -lrcont
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p rcor -L . -lrcont -lrcon
// (!target_ohos) EXEC: %compiler %cmp_opt %f -L . -lrcont -lrcon -lrcor -o %output %cmp_utest_opt
// (!target_ohos) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import rcont.*
import rcon.*
import rcor.*
@Test
class TestRcMember {
    @TestCase
    func testCase0(): Unit {
        @Expect(rcOpenPrefix(), "openPrs=[mut prop om: Int64]|openVrs=[ov: Int64]|openFns=[func of0(): Unit]")
    }

}

