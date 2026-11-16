/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-9
*- @TestCaseName: std.reflect — FunctionTypeInfo (无参) — AllApis_cl_0_retfloat
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_0_retfloat（typeVariant × acquisitionPath）
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
        @Expect[paramTypeNames](FunctionTypeInfo.of<() -> Float64>().parameters, [])
        @Expect(FunctionTypeInfo.of<() -> Float64>().returnType.name, "Float64")
        @Expect(FunctionTypeInfo.of<() -> Float64>().name != "", true)
        @Expect(FunctionTypeInfo.of<() -> Float64>().qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of<() -> Float64>().annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of<() -> Float64>().modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of<() -> Float64>().superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of<() -> Float64>().instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Float64>().instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Float64>().staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Float64>().staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Float64>().findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of<() -> Float64>().findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of<() -> Float64>().getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<() -> Float64>().isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of<() -> Float64>().hashCode() == FunctionTypeInfo.of<() -> Float64>().hashCode(), true)
        @Expect(FunctionTypeInfo.of<() -> Float64>().toString() != "", true)
        @Expect(FunctionTypeInfo.of<() -> Float64>() == FunctionTypeInfo.of<() -> Float64>(), true)
        @Expect(!(FunctionTypeInfo.of<() -> Float64>() != FunctionTypeInfo.of<() -> Float64>()), true)
        @Expect[anyValue](FunctionTypeInfo.of<() -> Float64>().apply({ => 3.5f64 }, []), 3.5f64)
        @Expect(!(FunctionTypeInfo.of<() -> Float64>() == FunctionTypeInfo.of<() -> String>()), true)
        @Expect(FunctionTypeInfo.of<() -> Float64>() != FunctionTypeInfo.of<() -> String>(), true)
    }

}

