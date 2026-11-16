/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-2
*- @TestCaseName: std.reflect — FunctionTypeInfo (函数引用) — AllApis_sm_doubleIt
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_sm_doubleIt（typeVariant × acquisitionPath）
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
class TestFtiRef {
    @TestCase
    func testCase0(): Unit {
        @Expect[paramTypeNames](FunctionTypeInfo.of(FtiStatic.doubleIt).parameters, ["Int64"])
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).returnType.name, "Int64")
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).name != "", true)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of(FtiStatic.doubleIt).annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of(FtiStatic.doubleIt).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of(FtiStatic.doubleIt).superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of(FtiStatic.doubleIt).findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).hashCode() == FunctionTypeInfo.of(FtiStatic.doubleIt).hashCode(), true)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt).toString() != "", true)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt) == FunctionTypeInfo.of(FtiStatic.doubleIt), true)
        @Expect(!(FunctionTypeInfo.of(FtiStatic.doubleIt) != FunctionTypeInfo.of(FtiStatic.doubleIt)), true)
        @Expect[anyValue](FunctionTypeInfo.of(FtiStatic.doubleIt).apply(FtiStatic.doubleIt, [21]), 42)
        @Expect(!(FunctionTypeInfo.of(FtiStatic.doubleIt) == FunctionTypeInfo.of<(Int64) -> String>()), true)
        @Expect(FunctionTypeInfo.of(FtiStatic.doubleIt) != FunctionTypeInfo.of<(Int64) -> String>(), true)
    }

}

