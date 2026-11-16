/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-38
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_UIntNative
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_UIntNative（typeVariant × acquisitionPath）
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
        @Expect(PrimitiveTypeInfo.get("UIntNative").name, "UIntNative")
        @Expect(PrimitiveTypeInfo.get("UIntNative").qualifiedName, "UIntNative")
        @Expect(PrimitiveTypeInfo.get("UIntNative").toString() != "", true)
        @Expect(PrimitiveTypeInfo.get("UIntNative").hashCode() == PrimitiveTypeInfo.get("UIntNative").hashCode(), true)
        @Expect(PrimitiveTypeInfo.get("UIntNative") == PrimitiveTypeInfo.get("UIntNative"), true)
        @Expect(!(PrimitiveTypeInfo.get("UIntNative") != PrimitiveTypeInfo.get("UIntNative")), true)
        @Expect(!(PrimitiveTypeInfo.get("UIntNative") == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.get("UIntNative") != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.get("UIntNative").instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("UIntNative").instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("UIntNative").staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("UIntNative").staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("UIntNative").getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.get("UIntNative").getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("UIntNative").getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("UIntNative").getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.get("UIntNative").getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("UIntNative").getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.get("UIntNative").annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.get("UIntNative").findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.get("UIntNative").findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.get("UIntNative").getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.get("UIntNative").superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.get("UIntNative").modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.get("UIntNative").isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

