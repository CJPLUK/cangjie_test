/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — GenericTypeInfo (负面) — MemberQueryNotfound
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo MemberQueryNotfound（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测泛型函数/持有类已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过宿主函数信息的 genericParams 拿到 GenericTypeInfo
*   -#按 Rule 预言验证 ==/!=/name/继承面/空集行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
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
import std.collection.*
import upstream.*
import utils.*
@Test
class TestGtiNegative {
    @TestCase
    func testCase0(): Unit {
        @ExpectThrows[InfoNotFoundException](findGfunc("id").genericParams.toArray()[0i64].getInstanceFunction("anyFunction", []))
        @ExpectThrows[InfoNotFoundException](findGfunc("id").genericParams.toArray()[0i64].getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](findGfunc("id").genericParams.toArray()[0i64].getStaticFunction("anyFunction", []))
        @ExpectThrows[InfoNotFoundException](findGfunc("id").genericParams.toArray()[0i64].getStaticProperty("anyFunction"))
    }

}

