/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-13
*- @TestCaseName: std.reflect — FunctionTypeInfo (单参) — AllApis_cl_1_rune_retrune_id
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_1_rune_retrune_id（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测函数值已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 FunctionTypeInfo
*   -#按 Rule 预言验证属性/继承/调用/相等行为
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
class TestFtiSingle {
    @TestCase
    func testCase0(): Unit {
        @Expect[paramTypeNames](FunctionTypeInfo.of<(Rune) -> Rune>().parameters, ["Rune"])
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().returnType.name, "Rune")
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().name != "", true)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of<(Rune) -> Rune>().annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of<(Rune) -> Rune>().modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of<(Rune) -> Rune>().superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of<(Rune) -> Rune>().findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().hashCode() == FunctionTypeInfo.of<(Rune) -> Rune>().hashCode(), true)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>().toString() != "", true)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>() == FunctionTypeInfo.of<(Rune) -> Rune>(), true)
        @Expect(!(FunctionTypeInfo.of<(Rune) -> Rune>() != FunctionTypeInfo.of<(Rune) -> Rune>()), true)
        @Expect[anyValue](FunctionTypeInfo.of<(Rune) -> Rune>().apply({ p0: Rune => p0 }, [r'a']), r'a')
        @Expect(!(FunctionTypeInfo.of<(Rune) -> Rune>() == FunctionTypeInfo.of<(Rune) -> String>()), true)
        @Expect(FunctionTypeInfo.of<(Rune) -> Rune>() != FunctionTypeInfo.of<(Rune) -> String>(), true)
    }

}

