/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-7
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_Rune
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_Rune（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 PrimitiveTypeInfo
*   -#按 Rule 预言验证成员/注解/结构/相等行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: ../../../utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %f -L . -lutils -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import std.collection.*
import utils.*
@Test
class TestPtiAcq {
    @TestCase
    func testCase0(): Unit {
        @Expect(PrimitiveTypeInfo.of<Rune>().name, "Rune")
        @Expect(PrimitiveTypeInfo.of<Rune>().qualifiedName, "Rune")
        @Expect(PrimitiveTypeInfo.of<Rune>().toString() != "", true)
        @Expect(PrimitiveTypeInfo.of<Rune>().hashCode() == PrimitiveTypeInfo.of<Rune>().hashCode(), true)
        @Expect(PrimitiveTypeInfo.of<Rune>() == PrimitiveTypeInfo.of<Rune>(), true)
        @Expect(!(PrimitiveTypeInfo.of<Rune>() != PrimitiveTypeInfo.of<Rune>()), true)
        @Expect(!(PrimitiveTypeInfo.of<Rune>() == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.of<Rune>() != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.of<Rune>().instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Rune>().instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Rune>().staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Rune>().staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Rune>().getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of<Rune>().getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Rune>().getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Rune>().getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of<Rune>().getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Rune>().getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.of<Rune>().annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.of<Rune>().findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.of<Rune>().findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.of<Rune>().getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.of<Rune>().superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.of<Rune>().modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.of<Rune>().isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

