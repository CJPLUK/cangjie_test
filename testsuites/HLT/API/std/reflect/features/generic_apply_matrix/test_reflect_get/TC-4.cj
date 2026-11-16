/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-4
*- @TestCaseName: std.reflect — get/查询轴消息契约（探针锚定 1.3.0-alpha.02） — CtorGetMissing
*- @TestCaseType: 功能测试
*- @Design Description: 场景矩阵：CtorGetMissing（apply/get 消息契约）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测形状已编译进 upstream 静态库
*- @Brief: 描述测试步骤
*   -#按场景构造 apply/get 调用
*   -#以 utils 消息 oracle 断言异常消息文本或成功结果
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，消息文本与消息契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: upstream ../../../utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %f -L . -lupstream -lutils -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import upstream.*
import std.collection.*
import utils.*
@Test
class TestReflectGet {
    @TestCase
    func testCase0(): Unit {
        @Expect(msgCtorGet(cti(mkGC1()), [PrimitiveTypeInfo.get("Bool")]), "Can not find the specified constructor")
    }

}

