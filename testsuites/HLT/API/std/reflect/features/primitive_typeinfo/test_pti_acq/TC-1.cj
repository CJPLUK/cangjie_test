/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_Nothing
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_Nothing（typeVariant × acquisitionPath）
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
        @Expect(PrimitiveTypeInfo.of<Nothing>().name, "Nothing")
        @Expect(PrimitiveTypeInfo.of<Nothing>().qualifiedName, "Nothing")
        @Expect(PrimitiveTypeInfo.of<Nothing>().toString() != "", true)
        @Expect(PrimitiveTypeInfo.of<Nothing>().hashCode() == PrimitiveTypeInfo.of<Nothing>().hashCode(), true)
        @Expect(PrimitiveTypeInfo.of<Nothing>() == PrimitiveTypeInfo.of<Nothing>(), true)
        @Expect(!(PrimitiveTypeInfo.of<Nothing>() != PrimitiveTypeInfo.of<Nothing>()), true)
        @Expect(!(PrimitiveTypeInfo.of<Nothing>() == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.of<Nothing>() != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.of<Nothing>().instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Nothing>().instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Nothing>().staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Nothing>().staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Nothing>().getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of<Nothing>().getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Nothing>().getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Nothing>().getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of<Nothing>().getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Nothing>().getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.of<Nothing>().annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.of<Nothing>().findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.of<Nothing>().findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.of<Nothing>().getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.of<Nothing>().superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.of<Nothing>().modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.of<Nothing>().isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

