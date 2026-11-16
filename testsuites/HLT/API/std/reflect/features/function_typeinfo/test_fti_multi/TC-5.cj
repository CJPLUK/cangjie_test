/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-5
*- @TestCaseName: std.reflect — FunctionTypeInfo (多参) — AllApis_cl_2_ib_retbool_cond
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_2_ib_retbool_cond（typeVariant × acquisitionPath）
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
class TestFtiMulti {
    @TestCase
    func testCase0(): Unit {
        @Expect[paramTypeNames](FunctionTypeInfo.of<(Int64, Bool) -> Bool>().parameters, ["Int64", "Bool"])
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().returnType.name, "Bool")
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().name != "", true)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of<(Int64, Bool) -> Bool>().annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of<(Int64, Bool) -> Bool>().modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of<(Int64, Bool) -> Bool>().superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of<(Int64, Bool) -> Bool>().findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().hashCode() == FunctionTypeInfo.of<(Int64, Bool) -> Bool>().hashCode(), true)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>().toString() != "", true)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>() == FunctionTypeInfo.of<(Int64, Bool) -> Bool>(), true)
        @Expect(!(FunctionTypeInfo.of<(Int64, Bool) -> Bool>() != FunctionTypeInfo.of<(Int64, Bool) -> Bool>()), true)
        @Expect[anyValue](FunctionTypeInfo.of<(Int64, Bool) -> Bool>().apply({ p0: Int64, p1: Bool => if (p1) { p0 > 0 } else { p0 < 0 } }, [-5, false]), true)
        @Expect(!(FunctionTypeInfo.of<(Int64, Bool) -> Bool>() == FunctionTypeInfo.of<(Int64, Bool) -> String>()), true)
        @Expect(FunctionTypeInfo.of<(Int64, Bool) -> Bool>() != FunctionTypeInfo.of<(Int64, Bool) -> String>(), true)
    }

}

