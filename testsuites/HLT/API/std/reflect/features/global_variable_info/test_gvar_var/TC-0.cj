/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — GlobalVariableInfo (var) — Gvar_var_int64_none
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Gvar_var_int64_none（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测全局变量已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 GlobalVariableInfo
*   -#按 Rule 预言验证成员/注解/值读写/相等行为
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
class TestGvarVar {
    @TestCase
    func testCase0(): Unit {
        @Expect(findGvar("var_int64_none").name, "var_int64_none")
        @Expect(findGvar("var_int64_none").typeInfo.name, "Int64")
        @Expect(findGvar("var_int64_none").hashCode() == findGvar("var_int64_none").hashCode(), true)
        @Expect(findGvar("var_int64_none").toString() != "", true)
        @Expect(findGvar("var_int64_none") == findGvar("var_int64_none"), true)
        @Expect(!(findGvar("var_int64_none") != findGvar("var_int64_none")), true)
        @Expect(!(findGvar("var_int64_none") == PackageInfo.get("upstream").getVariable("sentinelVar")), true)
        @Expect(findGvar("var_int64_none") != PackageInfo.get("upstream").getVariable("sentinelVar"), true)
        @Expect[anyValue](findGvar("var_int64_none").getValue(), 0)
        findGvar("var_int64_none").setValue(100)
        @Expect[anyValue](findGvar("var_int64_none").getValue(), 100)
        @Expect(findGvar("var_int64_none").isMutable(), true)
        @Expect[annotations](findGvar("var_int64_none").annotations, [])
        @Expect[annotationsArray](findGvar("var_int64_none").findAllAnnotations<Tag>(), [])
        @Expect(findGvar("var_int64_none").findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](findGvar("var_int64_none").getAllAnnotations(), [])
        @ExpectThrows[IllegalTypeException](findGvar("var_int64_none").setValue("wrong"))
    }

}

