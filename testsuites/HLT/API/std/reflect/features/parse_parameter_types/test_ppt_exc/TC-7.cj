/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-7
*- @TestCaseName: std.reflect — parseParameterTypes (异常) — AllUses_err_default_value
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllUses_err_default_value（inputVariant × resultUse）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测宿主类已编译进 upstream 动态库（如该 combo 需要）
*- @Brief: 描述测试步骤
*   -#调用 parseParameterTypes 解析输入限定名称字符串
*   -#按 Rule 预言验证解析结果/类型身份/供参集成/异常行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: ../../../utils upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %f -L . -lupstream -lutils -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import std.collection.*
import upstream.*
import utils.*
@Test
class TestPptExc {
    @TestCase
    func testCase0(): Unit {
        @ExpectThrows[InfoNotFoundException](parseParameterTypes("Int64 = 0"))
    }

}

