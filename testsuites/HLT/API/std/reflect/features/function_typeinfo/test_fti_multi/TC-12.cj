/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-12
*- @TestCaseName: std.reflect — FunctionTypeInfo (多参) — AllApis_cl_3_sbi_retstr_fmt
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_cl_3_sbi_retstr_fmt（typeVariant × acquisitionPath）
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
        @Expect[paramTypeNames](FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).parameters, ["String", "Bool", "Int64"])
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).returnType.name, "String")
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).name != "", true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).hashCode() == FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).hashCode(), true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).toString() != "", true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }) == FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }), true)
        @Expect(!(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }) != FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } })), true)
        @Expect[anyValue](FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }).apply({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }, ["id", true, 7]), "id7")
        @Expect(!(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }) == FunctionTypeInfo.of<(String, Bool, Int64) -> Int64>()), true)
        @Expect(FunctionTypeInfo.of({ p0: String, p1: Bool, p2: Int64 => if (p1) { p0 + p2.toString() } else { "-" } }) != FunctionTypeInfo.of<(String, Bool, Int64) -> Int64>(), true)
    }

}

