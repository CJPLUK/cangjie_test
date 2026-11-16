/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-46
*- @TestCaseName: std.reflect — PrimitiveTypeInfo (acquisition) — Pti_Float32
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pti_Float32（typeVariant × acquisitionPath）
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
        @Expect(PrimitiveTypeInfo.of<Float32>().name, "Float32")
        @Expect(PrimitiveTypeInfo.of<Float32>().qualifiedName, "Float32")
        @Expect(PrimitiveTypeInfo.of<Float32>().toString() != "", true)
        @Expect(PrimitiveTypeInfo.of<Float32>().hashCode() == PrimitiveTypeInfo.of<Float32>().hashCode(), true)
        @Expect(PrimitiveTypeInfo.of<Float32>() == PrimitiveTypeInfo.of<Float32>(), true)
        @Expect(!(PrimitiveTypeInfo.of<Float32>() != PrimitiveTypeInfo.of<Float32>()), true)
        @Expect(!(PrimitiveTypeInfo.of<Float32>() == PrimitiveTypeInfo.get("Int64")), true)
        @Expect(PrimitiveTypeInfo.of<Float32>() != PrimitiveTypeInfo.get("Int64"), true)
        @Expect(PrimitiveTypeInfo.of<Float32>().instanceFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Float32>().instanceProperties.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Float32>().staticFunctions.toArray().size, 0i64)
        @Expect(PrimitiveTypeInfo.of<Float32>().staticProperties.toArray().size, 0i64)
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Float32>().getInstanceFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of<Float32>().getInstanceFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Float32>().getInstanceProperty("__nonExistent__"))
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Float32>().getStaticFunction("__nonExistent__", []))
        @Expect[strArrayContent](PrimitiveTypeInfo.of<Float32>().getStaticFunctions("__nonExistent__"), [])
        @ExpectThrows[InfoNotFoundException](PrimitiveTypeInfo.of<Float32>().getStaticProperty("__nonExistent__"))
        @Expect[annotations](PrimitiveTypeInfo.of<Float32>().annotations, [])
        @Expect[annotationsArray](PrimitiveTypeInfo.of<Float32>().findAllAnnotations<PtiTag>(), [])
        @Expect(PrimitiveTypeInfo.of<Float32>().findAnnotation<PtiTag>().isNone(), true)
        @Expect(PrimitiveTypeInfo.of<Float32>().getAllAnnotations().size, 0i64)
        @Expect[containsIfaceName](PrimitiveTypeInfo.of<Float32>().superInterfaces, "Any")
        @Expect[notContainsModifiers](PrimitiveTypeInfo.of<Float32>().modifiers, ["open", "abstract", "sealed"])
        @Expect(PrimitiveTypeInfo.of<Float32>().isSubtypeOf(TypeInfo.of<Any>()), true)
    }

}

