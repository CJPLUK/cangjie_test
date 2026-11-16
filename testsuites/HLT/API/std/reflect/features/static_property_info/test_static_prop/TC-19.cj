/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-19
*- @TestCaseName: std.reflect — StaticPropertyInfo — AnnotatedStaticPropClass × valid × fromGetStaticProperty
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
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").name, "annotatedProp")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").annotations.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").toString(), "static prop annotatedProp: Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").findAllAnnotations<StaticPropAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").findAnnotation<StaticPropAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").getAllAnnotations().size, 1i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").getValue()).name == "Int64")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp").setValue(100i64))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").name, "multiAnnotatedProp")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").typeInfo.name, "String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").toString(), "static prop multiAnnotatedProp: String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").findAllAnnotations<StaticPropAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").findAnnotation<StaticPropAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").getValue()).name == "String")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp").setValue("new-value"))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").name, "duplicateAnnotatedProp")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").typeInfo.name, "Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").toString(), "static prop duplicateAnnotatedProp: Bool")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").findAllAnnotations<StaticPropAnnotation>().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").findAnnotation<StaticPropAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").getAllAnnotations().size, 2i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").getValue()).name == "Bool")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("duplicateAnnotatedProp").setValue(true))
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp") == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp"), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp") != ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp"), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp") == ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp"), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("annotatedProp") != ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").getStaticProperty("multiAnnotatedProp"), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().size, 3i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticPropClass").staticProperties.toArray().get(0i64).getOrThrow().name, "annotatedProp")
    }

}

