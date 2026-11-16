/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — EnumTypeInfo (构造子注解) — AnnotCtors_AnnotatedEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AnnotCtors_AnnotatedEnum（typeVariant × acquisitionPath）
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

// LEVEL: 0
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
class TestEtiAnnot {
    @TestCase
    func testCase0(): Unit {
        @Expect[annotations](EnumTypeInfo.of(AnnotatedEnum.A1).getConstructor("A1", argsCount: 0i64).annotations, [Dup(), Dup()])
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").name, "AnnotatedEnum")
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").qualifiedName, "upstream.AnnotatedEnum")
        @Expect[annotations](EnumTypeInfo.get("upstream.AnnotatedEnum").annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.AnnotatedEnum").findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.get("upstream.AnnotatedEnum").modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.get("upstream.AnnotatedEnum").superInterfaces, "Any")
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").hashCode() == EnumTypeInfo.get("upstream.AnnotatedEnum").hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").toString(), "upstream.AnnotatedEnum")
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum") == EnumTypeInfo.get("upstream.AnnotatedEnum"), true)
        @Expect(!(EnumTypeInfo.get("upstream.AnnotatedEnum") != EnumTypeInfo.get("upstream.AnnotatedEnum")), true)
        @Expect(!(EnumTypeInfo.get("upstream.AnnotatedEnum") == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum") != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.get("upstream.AnnotatedEnum").constructors, ["A1", "A2", "A3"])
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1").name, "A1")
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).qualifiedName, "upstream.AnnotatedEnum.A1")
        @Expect[anyValue](EnumTypeInfo.get("upstream.AnnotatedEnum").construct("A1", []), AnnotatedEnum.A1)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").destruct(AnnotatedEnum.A1)[0i64].qualifiedName, "upstream.AnnotatedEnum.A1")
        @Expect[anyValue](EnumTypeInfo.get("upstream.AnnotatedEnum").destruct(AnnotatedEnum.A1)[1i64], ArrayList<Any>())
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).name, "A1")
        @Expect[paramTypeNames](EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).parameters, Array<String>())
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).enumTypeInfo.qualifiedName, "upstream.AnnotatedEnum")
        @Expect[anyValue](EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).apply([]), AnnotatedEnum.A1)
        @Expect[anyValue](EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).getAssociatedValues(AnnotatedEnum.A1), ArrayList<Any>())
        @Expect[annotations](EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).getAllAnnotations(), [Dup(), Dup()])
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).hashCode() == EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64).toString(), "upstream.AnnotatedEnum.A1")
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64) == EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64), true)
        @Expect(!(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64) != EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64)), true)
        @Expect(!(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64) == EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A2", argsCount: 1i64)), true)
        @Expect(EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A1", argsCount: 0i64) != EnumTypeInfo.get("upstream.AnnotatedEnum").getConstructor("A2", argsCount: 1i64), true)
    }

}

