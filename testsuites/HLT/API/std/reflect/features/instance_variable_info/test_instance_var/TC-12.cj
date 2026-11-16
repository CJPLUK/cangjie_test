/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-12
*- @TestCaseName: std.reflect — InstanceVariableInfo — VarOnlyClass × valid × fromGetInstanceVariable
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 InstanceVariableInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 InstanceVariableInfo 引用（getInstanceVariable / instanceVariables）
*   -#通过 Rule 预言验证 name/typeInfo/modifiers/annotations/getValue/setValue/isMutable/相等性 的返回结果或异常路径
*- @Expect: 用例的预期结果
*   -#所有@Expect/@ExpectThrows断言通过，反射API返回值/异常与Rule预言一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: ../../../utils upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %f -L . -lutils -lupstream -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import utils.*
import upstream.*
import std.reflect.*
@Test
class TestInstanceVar {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").name, "value")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").typeInfo.name, "String")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").toString(), "value: String")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").hashCode() == ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").findAllAnnotations<VarAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").findAnnotation<VarAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").getAllAnnotations().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").getValue(VarOnlyClass())).name == "String")
        let varInstance0 = VarOnlyClass()
        ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").setValue(varInstance0, "new-value")
        @Expect[anyValue](ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value").getValue(varInstance0), "new-value")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").name, "number")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").toString(), "number: Int64")
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").hashCode() == ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").findAllAnnotations<VarAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").findAnnotation<VarAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").getAllAnnotations().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").getValue(VarOnlyClass())).name == "Int64")
        let varInstance1 = VarOnlyClass()
        ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").setValue(varInstance1, 100i64)
        @Expect[anyValue](ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number").getValue(varInstance1), 100i64)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value") == ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value"), true)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value") != ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value"), false)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value") == ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number"), false)
        @Expect(ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("value") != ClassTypeInfo.get("upstream.VarOnlyClass").getInstanceVariable("number"), true)
    }

}

