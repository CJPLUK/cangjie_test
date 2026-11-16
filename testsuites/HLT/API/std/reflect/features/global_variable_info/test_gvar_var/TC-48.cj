/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-48
*- @TestCaseName: std.reflect — GlobalVariableInfo (var) — Gvar_中文变量
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Gvar_中文变量（typeVariant × acquisitionPath）
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
class TestGvarVar {
    @TestCase
    func testCase0(): Unit {
        @Expect(findGvar("中文变量").name, "中文变量")
        @Expect(findGvar("中文变量").typeInfo.name, "Int64")
        @Expect(findGvar("中文变量").hashCode() == findGvar("中文变量").hashCode(), true)
        @Expect(findGvar("中文变量").toString() != "", true)
        @Expect(findGvar("中文变量") == findGvar("中文变量"), true)
        @Expect(!(findGvar("中文变量") != findGvar("中文变量")), true)
        @Expect(!(findGvar("中文变量") == PackageInfo.get("upstream").getVariable("sentinelVar")), true)
        @Expect(findGvar("中文变量") != PackageInfo.get("upstream").getVariable("sentinelVar"), true)
        @Expect[anyValue](findGvar("中文变量").getValue(), 9)
        findGvar("中文变量").setValue(100)
        @Expect[anyValue](findGvar("中文变量").getValue(), 100)
        @Expect(findGvar("中文变量").isMutable(), true)
        @Expect[annotations](findGvar("中文变量").annotations, [])
        @Expect[annotationsArray](findGvar("中文变量").findAllAnnotations<Tag>(), [])
        @Expect(findGvar("中文变量").findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](findGvar("中文变量").getAllAnnotations(), [])
        @ExpectThrows[IllegalTypeException](findGvar("中文变量").setValue("wrong"))
    }

}

