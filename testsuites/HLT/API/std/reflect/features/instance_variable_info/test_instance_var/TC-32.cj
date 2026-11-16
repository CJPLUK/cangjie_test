/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-32
*- @TestCaseName: std.reflect — InstanceVariableInfo — AnnotatedVarClass × valid × fromGetInstanceVariable
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
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").name, "annotatedVar")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").annotations.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").toString(), "annotatedVar: Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").hashCode() == ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").findAllAnnotations<VarAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").findAnnotation<VarAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").getAllAnnotations().size, 1i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.VarAnnotation")
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").getValue(AnnotatedVarClass())).name == "Int64")
        let varInstance0 = AnnotatedVarClass()
        ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").setValue(varInstance0, 100i64)
        @Expect[anyValue](ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar").getValue(varInstance0), 100i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").name, "multiAnnotatedVar")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").typeInfo.name, "String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").toString(), "multiAnnotatedVar: String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").hashCode() == ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").findAllAnnotations<VarAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").findAnnotation<VarAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.VarAnnotation")
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").getValue(AnnotatedVarClass())).name == "String")
        let varInstance1 = AnnotatedVarClass()
        ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").setValue(varInstance1, "new-value")
        @Expect[anyValue](ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar").getValue(varInstance1), "new-value")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").name, "duplicateAnnotatedVar")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").typeInfo.name, "Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").toString(), "duplicateAnnotatedVar: Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").hashCode() == ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").isMutable(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").findAllAnnotations<VarAnnotation>().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").findAnnotation<VarAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.VarAnnotation")
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").getValue(AnnotatedVarClass())).name == "Bool")
        let varInstance2 = AnnotatedVarClass()
        ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").setValue(varInstance2, true)
        @Expect[anyValue](ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("duplicateAnnotatedVar").getValue(varInstance2), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar") == ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar"), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar") != ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar"), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar") == ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar"), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("annotatedVar") != ClassTypeInfo.get("upstream.AnnotatedVarClass").getInstanceVariable("multiAnnotatedVar"), true)
    }

}

