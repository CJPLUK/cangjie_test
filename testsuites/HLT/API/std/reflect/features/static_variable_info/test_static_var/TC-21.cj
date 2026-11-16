/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-21
*- @TestCaseName: std.reflect — StaticVariableInfo — AnnotatedStaticVarClass × valid × fromGetStaticVariable
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 StaticVariableInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 StaticVariableInfo 引用（getStaticVariable / staticVariables）
*   -#通过 Rule 预言验证 name/typeInfo/modifiers/annotations/getValue/setValue/相等性 的返回结果或异常路径
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
class TestStaticVar {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").name, "annotatedVar")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").annotations.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").toString(), "static annotatedVar: Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").findAllAnnotations<StaticVarAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").findAnnotation<StaticVarAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").getAllAnnotations().size, 1i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").getValue()).name == "Int64")
        ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").setValue(100i64)
        @Expect[anyValue](ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar").getValue(), 100i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").name, "multiAnnotatedVar")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").typeInfo.name, "String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").toString(), "static multiAnnotatedVar: String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").findAllAnnotations<StaticVarAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").findAnnotation<StaticVarAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").getValue()).name == "String")
        ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").setValue("new-value")
        @Expect[anyValue](ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar").getValue(), "new-value")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").name, "duplicateAnnotatedVar")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").typeInfo.name, "Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").toString(), "static duplicateAnnotatedVar: Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").findAllAnnotations<StaticVarAnnotation>().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").findAnnotation<StaticVarAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").getValue()).name == "Bool")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("duplicateAnnotatedVar").setValue(true))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar") == ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar"), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar") != ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar"), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar") == ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar"), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("annotatedVar") != ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").getStaticVariable("multiAnnotatedVar"), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").staticVariables.toArray().size, 3i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticVarClass").staticVariables.toArray().get(0i64).getOrThrow().name, "annotatedVar")
    }

}

