/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — EnumTypeInfo (重载) — AllApis_OverloadEnum
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_OverloadEnum（typeVariant × acquisitionPath）
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
class TestEtiOverload {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).name, "OverloadEnum")
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).qualifiedName, "upstream.OverloadEnum")
        @Expect[annotations](EnumTypeInfo.of(OverloadEnum.W(1)).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.of(OverloadEnum.W(1)).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).findAnnotation<Tag>().isNone(), true)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getAllAnnotations().toArray().size, 0i64)
        @Expect[notContainsModifiers](EnumTypeInfo.of(OverloadEnum.W(1)).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](EnumTypeInfo.of(OverloadEnum.W(1)).superInterfaces, "Any")
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).instanceFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).instanceProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).staticFunctions.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).staticProperties.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).hashCode() == EnumTypeInfo.of(OverloadEnum.W(1)).hashCode(), true)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).toString(), "upstream.OverloadEnum")
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)) == EnumTypeInfo.of(OverloadEnum.W(1)), true)
        @Expect(!(EnumTypeInfo.of(OverloadEnum.W(1)) != EnumTypeInfo.of(OverloadEnum.W(1))), true)
        @Expect(!(EnumTypeInfo.of(OverloadEnum.W(1)) == EnumTypeInfo.get("upstream.EtiOtherEnum")), true)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)) != EnumTypeInfo.get("upstream.EtiOtherEnum"), true)
        @Expect[enumCtorNames](EnumTypeInfo.of(OverloadEnum.W(1)).constructors, ["W", "W", "W"])
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).qualifiedName, "upstream.OverloadEnum.W(Int64)")
        @Expect[anyValue](EnumTypeInfo.of(OverloadEnum.W(1)).construct("W(Int64)", [1]), OverloadEnum.W(1))
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).destruct(OverloadEnum.W(1))[0i64].qualifiedName, "upstream.OverloadEnum.W(Int64)")
        @Expect[anyValue](EnumTypeInfo.of(OverloadEnum.W(1)).destruct(OverloadEnum.W(1))[1i64], ArrayList<Any>([1]))
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).name, "W")
        @Expect[paramTypeNames](EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).parameters, ["Int64"])
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).enumTypeInfo.qualifiedName, "upstream.OverloadEnum")
        @Expect[anyValue](EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).apply([1]), OverloadEnum.W(1))
        @Expect[anyValue](EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).getAssociatedValues(OverloadEnum.W(1)), ArrayList<Any>([1]))
        @Expect[annotations](EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).annotations, [])
        @Expect[annotationsArray](EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).findAllAnnotations<Tag>(), Array<String>())
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotations](EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).hashCode() == EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).hashCode(), true)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64).toString(), "upstream.OverloadEnum.W(Int64)")
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64) == EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64), true)
        @Expect(!(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64) != EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64)), true)
        @Expect(!(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64) == EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 3i64)), true)
        @Expect(EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 1i64) != EnumTypeInfo.of(OverloadEnum.W(1)).getConstructor("W", argsCount: 3i64), true)
    }

}

