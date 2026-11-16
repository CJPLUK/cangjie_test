/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-30
*- @TestCaseName: std.reflect — GlobalFunctionInfo (基本信息) — AllApis_wrapper
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_wrapper（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测全局函数已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 GlobalFunctionInfo
*   -#按 Rule 预言验证成员/注解/调用/相等行为
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
import upstream.*
import std.collection.*
import utils.*
@Test
class TestGfuncInfo {
    @TestCase
    func testCase0(): Unit {
        @Expect(findGfunc("wrapper").name, "wrapper")
        @Expect(findGfunc("wrapper").returnType.name, "Int64")
        @Expect[parameterNames](findGfunc("wrapper").parameters, ["a", "b"])
        @Expect(findGfunc("wrapper").hashCode() == findGfunc("wrapper").hashCode(), true)
        @Expect(findGfunc("wrapper").toString() != "", true)
        @Expect[annotations](findGfunc("wrapper").annotations, [])
        @Expect(findGfunc("wrapper").findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](findGfunc("wrapper").findAllAnnotations<Tag>(), [])
        @Expect[annotations](findGfunc("wrapper").getAllAnnotations(), [])
        @Expect[genericParamNames](findGfunc("wrapper").genericParams, [])
        @Expect[anyValue](findGfunc("wrapper").apply([3, 4]), 7)
    }

}

