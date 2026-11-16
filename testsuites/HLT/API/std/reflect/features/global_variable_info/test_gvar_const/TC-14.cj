/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-14
*- @TestCaseName: std.reflect — GlobalVariableInfo (const) — Gvar_const_float64_single
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Gvar_const_float64_single（typeVariant × acquisitionPath）
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
class TestGvarConst {
    @TestCase
    func testCase0(): Unit {
        @Expect(findGvar("const_float64_single").name, "const_float64_single")
        @Expect(findGvar("const_float64_single").typeInfo.name, "Float64")
        @Expect(findGvar("const_float64_single").hashCode() == findGvar("const_float64_single").hashCode(), true)
        @Expect(findGvar("const_float64_single").toString() != "", true)
        @Expect(findGvar("const_float64_single") == findGvar("const_float64_single"), true)
        @Expect(!(findGvar("const_float64_single") != findGvar("const_float64_single")), true)
        @Expect(!(findGvar("const_float64_single") == PackageInfo.get("upstream").getVariable("sentinelVar")), true)
        @Expect(findGvar("const_float64_single") != PackageInfo.get("upstream").getVariable("sentinelVar"), true)
        @Expect[anyValue](findGvar("const_float64_single").getValue(), 3.14)
        @ExpectThrows[IllegalSetException](findGvar("const_float64_single").setValue(6.28))
        @Expect(!findGvar("const_float64_single").isMutable(), true)
        @Expect[annotations](findGvar("const_float64_single").annotations, [Tag()])
        @Expect[annotationsArray](findGvar("const_float64_single").findAllAnnotations<Tag>(), ["Tag"])
        @Expect(findGvar("const_float64_single").findAnnotation<Tag>().isSome(), true)
        @Expect[annotations](findGvar("const_float64_single").getAllAnnotations(), [Tag()])
    }

}

