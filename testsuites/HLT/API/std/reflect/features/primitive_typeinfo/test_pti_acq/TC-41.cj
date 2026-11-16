/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-41
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_Float16
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_Float16（typeVariant × acquisitionPath）
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
        @Expect(PrimitiveTypeInfo.get("Float16").name, "Float16")
        @Expect(PrimitiveTypeInfo.get("Float16").qualifiedName, "Float16")
        @Expect(PrimitiveTypeInfo.get("Float16").toString() != "", true)
        @Expect(PrimitiveTypeInfo.get("Float16").hashCode() == PrimitiveTypeInfo.get("Float16").hashCode(), true)
        @Expect(PrimitiveTypeInfo.get("Float16") == PrimitiveTypeInfo.get("Float16"), true)
        @Expect(!(PrimitiveTypeInfo.get("Float16") != PrimitiveTypeInfo.get("Float16")), true)
        @Expect(!(PrimitiveTypeInfo.get("Float16") == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.get("Float16") != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.get("Float16").instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("Float16").instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("Float16").staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.get("Float16").staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("Float16").getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.get("Float16").getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("Float16").getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("Float16").getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.get("Float16").getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.get("Float16").getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.get("Float16").annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.get("Float16").findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.get("Float16").findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.get("Float16").getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.get("Float16").superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.get("Float16").modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.get("Float16").isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

