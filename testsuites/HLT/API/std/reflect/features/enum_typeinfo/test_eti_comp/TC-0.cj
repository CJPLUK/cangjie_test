/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — EnumTypeInfo (元组/函数关联值) — AllApis_CompositeEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_CompositeEnum（typeVariant × acquisitionPath）
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
class TestEtiComp {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").name, "CompositeEnum")
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").qualifiedName, "upstream.CompositeEnum")
        @Expect[annotations](EnumTypeInfo.get("upstream.CompositeEnum").annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.CompositeEnum").findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.get("upstream.CompositeEnum").modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.get("upstream.CompositeEnum").superInterfaces, "Any")
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").hashCode() == EnumTypeInfo.get("upstream.CompositeEnum").hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").toString(), "upstream.CompositeEnum")
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum") == EnumTypeInfo.get("upstream.CompositeEnum"), true)
        @Expect(!(EnumTypeInfo.get("upstream.CompositeEnum") != EnumTypeInfo.get("upstream.CompositeEnum")), true)
        @Expect(!(EnumTypeInfo.get("upstream.CompositeEnum") == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum") != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.get("upstream.CompositeEnum").constructors, ["C1", "C2", "C3"])
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).qualifiedName, "upstream.CompositeEnum.C1(Tuple<Unit, Unit>)")
        @Expect[anyValue](EnumTypeInfo.get("upstream.CompositeEnum").construct("C1(Tuple<Unit, Unit>)", [((), ())]), CompositeEnum.C1(((), ())))
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").destruct(CompositeEnum.C1(((), ())))[0i64].qualifiedName, "upstream.CompositeEnum.C1(Tuple<Unit, Unit>)")
        @Expect[anyValue](EnumTypeInfo.get("upstream.CompositeEnum").destruct(CompositeEnum.C1(((), ())))[1i64], ArrayList<Any>([((), ())]))
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).name, "C1")
        @Expect[paramTypeNames](EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).parameters, ["Tuple<Unit, Unit>"])
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).enumTypeInfo.qualifiedName, "upstream.CompositeEnum")
        @Expect[anyValue](EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).apply([((), ())]), CompositeEnum.C1(((), ())))
        @Expect[anyValue](EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).getAssociatedValues(CompositeEnum.C1(((), ()))), ArrayList<Any>([((), ())]))
        @Expect[annotations](EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).hashCode() == EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64).toString(), "upstream.CompositeEnum.C1(Tuple<Unit, Unit>)")
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64) == EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64), true)
        @Expect(!(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64) != EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64)), true)
        @Expect(!(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64) == EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C3", argsCount: 1i64)), true)
        @Expect(EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C1", argsCount: 1i64) != EnumTypeInfo.get("upstream.CompositeEnum").getConstructor("C3", argsCount: 1i64), true)
    }

}

