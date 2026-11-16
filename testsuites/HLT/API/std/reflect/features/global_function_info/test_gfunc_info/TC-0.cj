/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — GlobalFunctionInfo (基本信息) — AllApis_zeroParam
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_zeroParam（typeVariant × acquisitionPath）
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

// LEVEL: 0
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
        @Expect(findGfunc("zeroParam").name, "zeroParam")
        @Expect(findGfunc("zeroParam").returnType.name, "Int64")
        @Expect[parameterNames](findGfunc("zeroParam").parameters, [])
        @Expect(findGfunc("zeroParam").hashCode() == findGfunc("zeroParam").hashCode(), true)
        @Expect(findGfunc("zeroParam").toString() != "", true)
        @Expect[annotations](findGfunc("zeroParam").annotations, [])
        @Expect(findGfunc("zeroParam").findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](findGfunc("zeroParam").findAllAnnotations<Tag>(), [])
        @Expect[annotations](findGfunc("zeroParam").getAllAnnotations(), [])
        @Expect[genericParamNames](findGfunc("zeroParam").genericParams, [])
        @Expect[anyValue](findGfunc("zeroParam").apply([]), 42)
    }

}

