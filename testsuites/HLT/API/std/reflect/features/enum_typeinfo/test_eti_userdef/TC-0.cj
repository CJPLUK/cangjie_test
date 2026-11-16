/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — EnumTypeInfo (用户自定义关联值) — AllApis_UserDefEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_UserDefEnum（typeVariant × acquisitionPath）
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
class TestEtiUserdef {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").name, "UserDefEnum")
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").qualifiedName, "upstream.UserDefEnum")
        @Expect[annotations](EnumTypeInfo.get("upstream.UserDefEnum").annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.UserDefEnum").findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.get("upstream.UserDefEnum").modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.get("upstream.UserDefEnum").superInterfaces, "Any")
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").hashCode() == EnumTypeInfo.get("upstream.UserDefEnum").hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").toString(), "upstream.UserDefEnum")
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum") == EnumTypeInfo.get("upstream.UserDefEnum"), true)
        @Expect(!(EnumTypeInfo.get("upstream.UserDefEnum") != EnumTypeInfo.get("upstream.UserDefEnum")), true)
        @Expect(!(EnumTypeInfo.get("upstream.UserDefEnum") == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum") != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.get("upstream.UserDefEnum").constructors, ["U1", "U2", "U3"])
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).qualifiedName, "upstream.UserDefEnum.U1(upstream.HelperS)")
        @Expect[anyValue](EnumTypeInfo.get("upstream.UserDefEnum").construct("U1(upstream.HelperS)", [HelperS()]), UserDefEnum.U1(HelperS()))
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").destruct(UserDefEnum.U1(HelperS()))[0i64].qualifiedName, "upstream.UserDefEnum.U1(upstream.HelperS)")
        @Expect[anyValue](EnumTypeInfo.get("upstream.UserDefEnum").destruct(UserDefEnum.U1(HelperS()))[1i64], ArrayList<Any>([HelperS()]))
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).name, "U1")
        @Expect[paramTypeNames](EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).parameters, ["HelperS"])
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).enumTypeInfo.qualifiedName, "upstream.UserDefEnum")
        @Expect[anyValue](EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).apply([HelperS()]), UserDefEnum.U1(HelperS()))
        @Expect[anyValue](EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).getAssociatedValues(UserDefEnum.U1(HelperS())), ArrayList<Any>([HelperS()]))
        @Expect[annotations](EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).hashCode() == EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64).toString(), "upstream.UserDefEnum.U1(upstream.HelperS)")
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64) == EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64), true)
        @Expect(!(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64) != EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64)), true)
        @Expect(!(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64) == EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U3", argsCount: 1i64)), true)
        @Expect(EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U1", argsCount: 1i64) != EnumTypeInfo.get("upstream.UserDefEnum").getConstructor("U3", argsCount: 1i64), true)
    }

}

