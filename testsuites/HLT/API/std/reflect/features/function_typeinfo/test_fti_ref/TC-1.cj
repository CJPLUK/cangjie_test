/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — FunctionTypeInfo (函数引用) — AllApis_im_addFactor
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo AllApis_im_addFactor（typeVariant × acquisitionPath）
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
        @Expect[paramTypeNames](FunctionTypeInfo.of(FtiHolder(2).addFactor).parameters, ["Int64"])
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).returnType.name, "Int64")
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).name != "", true)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).qualifiedName != "", true)
        @Expect[annotations](FunctionTypeInfo.of(FtiHolder(2).addFactor).annotations, [])
        @Expect[notContainsModifiers](FunctionTypeInfo.of(FtiHolder(2).addFactor).modifiers, ["open", "abstract", "sealed"])
        @Expect[containsIfaceName](FunctionTypeInfo.of(FtiHolder(2).addFactor).superInterfaces, "Any")
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).instanceFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).instanceProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).staticFunctions.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).staticProperties.toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](FunctionTypeInfo.of(FtiHolder(2).addFactor).findAllAnnotations<Tag>(), [])
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).getAllAnnotations().toArray().size, 0i64)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).isSubtypeOf(TypeInfo.of<Any>()), true)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).hashCode() == FunctionTypeInfo.of(FtiHolder(2).addFactor).hashCode(), true)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor).toString() != "", true)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor) == FunctionTypeInfo.of(FtiHolder(2).addFactor), true)
        @Expect(!(FunctionTypeInfo.of(FtiHolder(2).addFactor) != FunctionTypeInfo.of(FtiHolder(2).addFactor)), true)
        @Expect[anyValue](FunctionTypeInfo.of(FtiHolder(2).addFactor).apply(FtiHolder(2).addFactor, [5]), 7)
        @Expect(!(FunctionTypeInfo.of(FtiHolder(2).addFactor) == FunctionTypeInfo.of<(Int64) -> String>()), true)
        @Expect(FunctionTypeInfo.of(FtiHolder(2).addFactor) != FunctionTypeInfo.of<(Int64) -> String>(), true)
    }

}

