/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-28
*- @TestCaseName: std.reflect — GlobalVariableInfo (let) — Gvar_let_arrInt64_dup
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Gvar_let_arrInt64_dup（typeVariant × acquisitionPath）
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
class TestGvarLet {
    @TestCase
    func testCase0(): Unit {
        @Expect(findGvar("let_arrInt64_dup").name, "let_arrInt64_dup")
        @Expect(findGvar("let_arrInt64_dup").typeInfo.name != "", true)
        @Expect(findGvar("let_arrInt64_dup").hashCode() == findGvar("let_arrInt64_dup").hashCode(), true)
        @Expect(findGvar("let_arrInt64_dup").toString() != "", true)
        @Expect(findGvar("let_arrInt64_dup") == findGvar("let_arrInt64_dup"), true)
        @Expect(!(findGvar("let_arrInt64_dup") != findGvar("let_arrInt64_dup")), true)
        @Expect(!(findGvar("let_arrInt64_dup") == PackageInfo.get("upstream").getVariable("sentinelVar")), true)
        @Expect(findGvar("let_arrInt64_dup") != PackageInfo.get("upstream").getVariable("sentinelVar"), true)
        @ExpectThrows[IllegalSetException](findGvar("let_arrInt64_dup").setValue([1, 2, 3]))
        @Expect(!findGvar("let_arrInt64_dup").isMutable(), true)
        @Expect[annotations](findGvar("let_arrInt64_dup").annotations, [Tag(), Tag()])
        @Expect[annotationsArray](findGvar("let_arrInt64_dup").findAllAnnotations<Tag>(), ["Tag", "Tag"])
        @Expect(findGvar("let_arrInt64_dup").findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](findGvar("let_arrInt64_dup").getAllAnnotations(), [Tag(), Tag()])
        findGvar("let_arrInt64_dup").getValue()
    }

}

