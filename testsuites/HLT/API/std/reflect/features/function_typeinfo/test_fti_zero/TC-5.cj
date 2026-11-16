/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-5
*- @TestCaseName: std.reflect — FunctionTypeInfo (无参) — AllApis_cl_0_retbool
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_0_retbool（typeVariant × acquisitionPath）
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
class TestFtiZero {
    @TestCase
    func testCase0(): Unit {
        @Expect[paramTypeNames](FunctionTypeInfo.of<() -> Bool>().parameters, [])
        @Expect(FunctionTypeInfo.of<() -> Bool>().returnType.name, "Bool")
        @Expect(FunctionTypeInfo.of<() -> Bool>().name != "", true)
        @Expect(FunctionTypeInfo.of<() -> Bool>().qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of<() -> Bool>().annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of<() -> Bool>().modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of<() -> Bool>().superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of<() -> Bool>().instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Bool>().instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Bool>().staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Bool>().staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Bool>().findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of<() -> Bool>().findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of<() -> Bool>().getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Bool>().isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of<() -> Bool>().hashCode() == FunctionTypeInfo.of<() -> Bool>().hashCode(), true)
        @Expect(FunctionTypeInfo.of<() -> Bool>().toString() != "", true)
        @Expect(FunctionTypeInfo.of<() -> Bool>() == FunctionTypeInfo.of<() -> Bool>(), true)
        @Expect(!(FunctionTypeInfo.of<() -> Bool>() != FunctionTypeInfo.of<() -> Bool>()), true)
        @Expect[anyValue](FunctionTypeInfo.of<() -> Bool>().apply({ => true }, []), true)
        @Expect(!(FunctionTypeInfo.of<() -> Bool>() == FunctionTypeInfo.of<() -> String>()), true)
        @Expect(FunctionTypeInfo.of<() -> Bool>() != FunctionTypeInfo.of<() -> String>(), true)
    }

}

