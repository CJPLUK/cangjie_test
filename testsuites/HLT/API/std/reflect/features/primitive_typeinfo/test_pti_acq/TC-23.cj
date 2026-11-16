/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-23
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_IntNative
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_IntNative（typeVariant × acquisitionPath）
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
        @Expect(PrimitiveTypeInfo.get("IntNative").name, "IntNative")
        @Expect(PrimitiveTypeInfo.get("IntNative").qualifiedName, "IntNative")
        @Expect(PrimitiveTypeInfo.get("IntNative").toString() != "", true)
        @Expect(PrimitiveTypeInfo.get("IntNative").hashCode() == PrimitiveTypeInfo.get("IntNative").hashCode(), true)
        @Expect(PrimitiveTypeInfo.get("IntNative") == PrimitiveTypeInfo.get("IntNative"), true)
        @Expect(!(PrimitiveTypeInfo.get("IntNative") != PrimitiveTypeInfo.get("IntNative")), true)
        @Expect(!(PrimitiveTypeInfo.get("IntNative") == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.get("IntNative") != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.get("IntNative").instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("IntNative").instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("IntNative").staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("IntNative").staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("IntNative").getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.get("IntNative").getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("IntNative").getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("IntNative").getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.get("IntNative").getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("IntNative").getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.get("IntNative").annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.get("IntNative").findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.get("IntNative").findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.get("IntNative").getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.get("IntNative").superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.get("IntNative").modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.get("IntNative").isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

