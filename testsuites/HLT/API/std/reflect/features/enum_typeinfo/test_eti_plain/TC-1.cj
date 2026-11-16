/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
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
class TestEtiPlain {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).name, "PlainEnum")
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).qualifiedName, "upstream.PlainEnum")
        @Expect[annotations](EnumTypeInfo.of(PlainEnum.Z1).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.of(PlainEnum.Z1).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.of(PlainEnum.Z1).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.of(PlainEnum.Z1).superInterfaces, "Any")
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).hashCode() == EnumTypeInfo.of(PlainEnum.Z1).hashCode(), true)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).toString(), "upstream.PlainEnum")
        @Expect(EnumTypeInfo.of(PlainEnum.Z1) == EnumTypeInfo.of(PlainEnum.Z1), true)
        @Expect(!(EnumTypeInfo.of(PlainEnum.Z1) != EnumTypeInfo.of(PlainEnum.Z1)), true)
        @Expect(!(EnumTypeInfo.of(PlainEnum.Z1) == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1) != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.of(PlainEnum.Z1).constructors, ["Z1", "Z2", "Z3"])
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1").name, "Z1")
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).qualifiedName, "upstream.PlainEnum.Z1")
        @Expect[anyValue](EnumTypeInfo.of(PlainEnum.Z1).construct("Z1", []), PlainEnum.Z1)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).destruct(PlainEnum.Z1)[0i64].qualifiedName, "upstream.PlainEnum.Z1")
        @Expect[anyValue](EnumTypeInfo.of(PlainEnum.Z1).destruct(PlainEnum.Z1)[1i64], ArrayList<Any>())
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).name, "Z1")
        @Expect[paramTypeNames](EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).parameters, Array<String>())
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).enumTypeInfo.qualifiedName, "upstream.PlainEnum")
        @Expect[anyValue](EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).apply([]), PlainEnum.Z1)
        @Expect[anyValue](EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).getAssociatedValues(PlainEnum.Z1), ArrayList<Any>())
        @Expect[annotations](EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).hashCode() == EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).hashCode(), true)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64).toString(), "upstream.PlainEnum.Z1")
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64) == EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64), true)
        @Expect(!(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64) != EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64)), true)
        @Expect(!(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64) == EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z3", argsCount: 0i64)), true)
        @Expect(EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z1", argsCount: 0i64) != EnumTypeInfo.of(PlainEnum.Z1).getConstructor("Z3", argsCount: 0i64), true)
    }

}

