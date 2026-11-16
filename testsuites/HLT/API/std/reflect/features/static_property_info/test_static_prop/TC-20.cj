/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-20
*- @TestCaseName: std.reflect — StaticPropertyInfo — AnnotatedStaticPropClass × valid × fromStaticProperties
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 StaticPropertyInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 StaticPropertyInfo 引用（getStaticProperty / staticProperties）
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
class TestStaticProp {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().name, "annotatedProp")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().annotations.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().toString(), "static prop annotatedProp: Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().findAllAnnotations<StaticPropAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().findAnnotation<StaticPropAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().getAllAnnotations().size, 1i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().getValue()).name == "Int64")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().setValue(100i64))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().name, "multiAnnotatedProp")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().typeInfo.name, "String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().toString(), "static prop multiAnnotatedProp: String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().findAllAnnotations<StaticPropAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().findAnnotation<StaticPropAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().getValue()).name == "String")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow().setValue("new-value"))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().name, "duplicateAnnotatedProp")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().typeInfo.name, "Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().toString(), "static prop duplicateAnnotatedProp: Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().findAllAnnotations<StaticPropAnnotation>().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().findAnnotation<StaticPropAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().getValue()).name == "Bool")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(2i64).getOrThrow().setValue(true))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow() != ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow() != ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(1i64).getOrThrow(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().size, 3i64)
    }

}

