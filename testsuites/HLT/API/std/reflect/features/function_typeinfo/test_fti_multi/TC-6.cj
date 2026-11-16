/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-6
*- @TestCaseName: std.reflect — FunctionTypeInfo (多参) — AllApis_cl_2_sb_retint_lencond
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_2_sb_retint_lencond（typeVariant × acquisitionPath）
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
        @Expect[paramTypeNames](FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).parameters, ["String", "Bool"])
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).returnType.name, "Int64")
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).name != "", true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).hashCode() == FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).hashCode(), true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).toString() != "", true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }) == FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }), true)
        @Expect(!(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }) != FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } })), true)
        @Expect[anyValue](FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }).apply({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }, ["abcd", true]), 4)
        @Expect(!(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }) == FunctionTypeInfo.of<(String, Bool) -> String>()), true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool => if (p1) { p0.size } else { 0 } }) != FunctionTypeInfo.of<(String, Bool) -> String>(), true)
    }

}

