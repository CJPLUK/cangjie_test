/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-15
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_Int16
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_Int16（typeVariant × acquisitionPath）
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
        @Expect(PrimitiveTypeInfo.of(1i16).name, "Int16")
        @Expect(PrimitiveTypeInfo.of(1i16).qualifiedName, "Int16")
        @Expect(PrimitiveTypeInfo.of(1i16).toString() != "", true)
        @Expect(PrimitiveTypeInfo.of(1i16).hashCode() == PrimitiveTypeInfo.of(1i16).hashCode(), true)
        @Expect(PrimitiveTypeInfo.of(1i16) == PrimitiveTypeInfo.of(1i16), true)
        @Expect(!(PrimitiveTypeInfo.of(1i16) != PrimitiveTypeInfo.of(1i16)), true)
        @Expect(!(PrimitiveTypeInfo.of(1i16) == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.of(1i16) != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.of(1i16).instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of(1i16).instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of(1i16).staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of(1i16).staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of(1i16).getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of(1i16).getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of(1i16).getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of(1i16).getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of(1i16).getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of(1i16).getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.of(1i16).annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.of(1i16).findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.of(1i16).findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.of(1i16).getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.of(1i16).superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.of(1i16).modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.of(1i16).isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

