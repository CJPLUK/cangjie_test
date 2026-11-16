/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — EnumTypeInfo (基础类型关联值) — AllApis_PrimEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_PrimEnum（typeVariant × acquisitionPath）
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
class TestEtiPrim {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").name, "PrimEnum")
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").qualifiedName, "upstream.PrimEnum")
        @Expect[annotations](EnumTypeInfo.get("upstream.PrimEnum").annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.PrimEnum").findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.get("upstream.PrimEnum").modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.get("upstream.PrimEnum").superInterfaces, "Any")
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").hashCode() == EnumTypeInfo.get("upstream.PrimEnum").hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").toString(), "upstream.PrimEnum")
        @Expect(EnumTypeInfo.get("upstream.PrimEnum") == EnumTypeInfo.get("upstream.PrimEnum"), true)
        @Expect(!(EnumTypeInfo.get("upstream.PrimEnum") != EnumTypeInfo.get("upstream.PrimEnum")), true)
        @Expect(!(EnumTypeInfo.get("upstream.PrimEnum") == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum") != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.get("upstream.PrimEnum").constructors, ["P1", "P2", "P3", "P4"])
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).qualifiedName, "upstream.PrimEnum.P1(Int64)")
        @Expect[anyValue](EnumTypeInfo.get("upstream.PrimEnum").construct("P1(Int64)", [42]), PrimEnum.P1(42))
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").destruct(PrimEnum.P1(42))[0i64].qualifiedName, "upstream.PrimEnum.P1(Int64)")
        @Expect[anyValue](EnumTypeInfo.get("upstream.PrimEnum").destruct(PrimEnum.P1(42))[1i64], ArrayList<Any>([42]))
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).name, "P1")
        @Expect[paramTypeNames](EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).parameters, ["Int64"])
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).enumTypeInfo.qualifiedName, "upstream.PrimEnum")
        @Expect[anyValue](EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).apply([42]), PrimEnum.P1(42))
        @Expect[anyValue](EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).getAssociatedValues(PrimEnum.P1(42)), ArrayList<Any>([42]))
        @Expect[annotations](EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).hashCode() == EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64).toString(), "upstream.PrimEnum.P1(Int64)")
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64) == EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64), true)
        @Expect(!(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64) != EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64)), true)
        @Expect(!(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64) == EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P4", argsCount: 0i64)), true)
        @Expect(EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P1", argsCount: 1i64) != EnumTypeInfo.get("upstream.PrimEnum").getConstructor("P4", argsCount: 0i64), true)
    }

}

