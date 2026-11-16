/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — FunctionTypeInfo (复合/嵌套) — AllApis_cl_1_arr_retint_len
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_1_arr_retint_len（typeVariant × acquisitionPath）
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
class TestFtiComp {
    @TestCase
    func testCase0(): Unit {
        @Expect[paramTypeNames](FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).parameters, ["Array<Int64>"])
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).returnType.name, "Int64")
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).name != "", true)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).hashCode() == FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).hashCode(), true)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).toString() != "", true)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }) == FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }), true)
        @Expect(!(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }) != FunctionTypeInfo.of({ p0: Array<Int64> => p0.size })), true)
        @Expect[anyValue](FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }).apply({ p0: Array<Int64> => p0.size }, [[1, 2, 3]]), 3)
        @Expect(!(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }) == FunctionTypeInfo.of<(Array<Int64>) -> String>()), true)
        @Expect(FunctionTypeInfo.of({ p0: Array<Int64> => p0.size }) != FunctionTypeInfo.of<(Array<Int64>) -> String>(), true)
    }

}

