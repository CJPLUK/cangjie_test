/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-2
*- @TestCaseName: std.reflect — EnumTypeInfo (泛型) — AllApis_GenericEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_GenericEnum（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测枚举类型已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 EnumTypeInfo
*   -#按 Rule 预言验证构造器/构造拆解/继承成员/相等行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: upstream ../../../utils
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// (!target_ohos) EXEC: %compiler %cmp_opt %f -L . -lupstream -lutils -o %output %cmp_utest_opt
// (!target_ohos) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import std.collection.*
import std.sort.*
import upstream.*
import utils.*
@Test
class TestEtiGeneric {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().name, "GenericEnum<Int64>")
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().qualifiedName, "upstream.GenericEnum<Int64>")
        @Expect[annotations](EnumTypeInfo.of<GenericEnum<Int64>>().annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.of<GenericEnum<Int64>>().findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.of<GenericEnum<Int64>>().modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.of<GenericEnum<Int64>>().superInterfaces, "Any")
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().hashCode() == EnumTypeInfo.of<GenericEnum<Int64>>().hashCode(), true)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().toString(), "upstream.GenericEnum<Int64>")
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>() == EnumTypeInfo.of<GenericEnum<Int64>>(), true)
        @Expect(!(EnumTypeInfo.of<GenericEnum<Int64>>() != EnumTypeInfo.of<GenericEnum<Int64>>()), true)
        @Expect(!(EnumTypeInfo.of<GenericEnum<Int64>>() == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>() != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.of<GenericEnum<Int64>>().constructors, ["G1", "G2"])
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1").name, "G1")
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).qualifiedName, "upstream.GenericEnum<Int64>.G1")
        @Expect[anyValue](EnumTypeInfo.of<GenericEnum<Int64>>().construct("G1", []), GenericEnum<Int64>.G1)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().destruct(GenericEnum<Int64>.G1)[0i64].qualifiedName, "upstream.GenericEnum<Int64>.G1")
        @Expect[anyValue](EnumTypeInfo.of<GenericEnum<Int64>>().destruct(GenericEnum<Int64>.G1)[1i64], ArrayList<Any>())
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).name, "G1")
        @Expect[paramTypeNames](EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).parameters, Array<String>())
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).enumTypeInfo.qualifiedName, "upstream.GenericEnum<Int64>")
        @Expect[anyValue](EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).apply([]), GenericEnum<Int64>.G1)
        @Expect[anyValue](EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).getAssociatedValues(GenericEnum<Int64>.G1), ArrayList<Any>())
        @Expect[annotations](EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).hashCode() == EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).hashCode(), true)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64).toString(), "upstream.GenericEnum<Int64>.G1")
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64) == EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64), true)
        @Expect(!(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64) != EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64)), true)
        @Expect(!(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64) == EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G2", argsCount: 1i64)), true)
        @Expect(EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G1", argsCount: 0i64) != EnumTypeInfo.of<GenericEnum<Int64>>().getConstructor("G2", argsCount: 1i64), true)
    }

}

