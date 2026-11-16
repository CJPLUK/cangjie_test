/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-10
*- @TestCaseName: std.reflect — FunctionTypeInfo (单参) — AllApis_cl_1_f64_retfloat_dbl
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_1_f64_retfloat_dbl（typeVariant × acquisitionPath）
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
        @Expect[paramTypeNames](FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).parameters, ["Float64"])
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).returnType.name, "Float64")
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).name != "", true)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).hashCode() == FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).hashCode(), true)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).toString() != "", true)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }) == FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }), true)
        @Expect(!(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }) != FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 })), true)
        @Expect[anyValue](FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }).apply({ p0: Float64 => p0 * 2.0 }, [1.5f64]), 3.0f64)
        @Expect(!(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }) == FunctionTypeInfo.of<(Float64) -> String>()), true)
        @Expect(FunctionTypeInfo.of({ p0: Float64 => p0 * 2.0 }) != FunctionTypeInfo.of<(Float64) -> String>(), true)
    }

}

