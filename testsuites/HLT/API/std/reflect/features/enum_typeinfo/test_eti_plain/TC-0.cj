/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — EnumTypeInfo (无关联值) — AllApis_PlainEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_PlainEnum（typeVariant × acquisitionPath）
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
class TestEtiPlain {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").name, "PlainEnum")
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").qualifiedName, "upstream.PlainEnum")
        @Expect[annotations](EnumTypeInfo.get("upstream.PlainEnum").annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.PlainEnum").findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.get("upstream.PlainEnum").modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.get("upstream.PlainEnum").superInterfaces, "Any")
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").hashCode() == EnumTypeInfo.get("upstream.PlainEnum").hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").toString(), "upstream.PlainEnum")
        @Expect(EnumTypeInfo.get("upstream.PlainEnum") == EnumTypeInfo.get("upstream.PlainEnum"), true)
        @Expect(!(EnumTypeInfo.get("upstream.PlainEnum") != EnumTypeInfo.get("upstream.PlainEnum")), true)
        @Expect(!(EnumTypeInfo.get("upstream.PlainEnum") == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum") != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.get("upstream.PlainEnum").constructors, ["Z1", "Z2", "Z3"])
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1").name, "Z1")
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).qualifiedName, "upstream.PlainEnum.Z1")
        @Expect[anyValue](EnumTypeInfo.get("upstream.PlainEnum").construct("Z1", []), PlainEnum.Z1)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").destruct(PlainEnum.Z1)[0i64].qualifiedName, "upstream.PlainEnum.Z1")
        @Expect[anyValue](EnumTypeInfo.get("upstream.PlainEnum").destruct(PlainEnum.Z1)[1i64], ArrayList<Any>())
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).name, "Z1")
        @Expect[paramTypeNames](EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).parameters, Array<String>())
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).enumTypeInfo.qualifiedName, "upstream.PlainEnum")
        @Expect[anyValue](EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).apply([]), PlainEnum.Z1)
        @Expect[anyValue](EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).getAssociatedValues(PlainEnum.Z1), ArrayList<Any>())
        @Expect[annotations](EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).hashCode() == EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64).toString(), "upstream.PlainEnum.Z1")
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64) == EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64), true)
        @Expect(!(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64) != EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64)), true)
        @Expect(!(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64) == EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z3", argsCount: 0i64)), true)
        @Expect(EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z1", argsCount: 0i64) != EnumTypeInfo.get("upstream.PlainEnum").getConstructor("Z3", argsCount: 0i64), true)
    }

}

