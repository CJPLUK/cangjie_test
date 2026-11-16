/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-72
*- @TestCaseName: std.reflect — StaticFunctionInfo — AnnotatedStaticFuncClass × valid × fromGetStaticFunction
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 StaticFunctionInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 StaticFunctionInfo 引用（getStaticFunction / staticFunctions / getStaticFunctions）
*   -#通过 Rule 预言验证 name/parameters/returnType/modifiers/annotations/apply/相等性 的返回结果或异常路径
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
class TestStaticFunc {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).name, "annotatedMethod")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).annotations.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).toString(), "static func annotatedMethod(): Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).findAllAnnotations<StaticFuncAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).findAnnotation<StaticFuncAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).getAllAnnotations().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).apply(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass"), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).apply(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass"), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []).annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.StaticFuncAnnotation")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).name, "multiAnnotatedMethod")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).toString(), "static func multiAnnotatedMethod(String): String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).hashCode() == ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).findAllAnnotations<StaticFuncAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).findAnnotation<StaticFuncAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).apply(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass"), ["hello"])).name == "String")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).apply(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass"), [PrimitiveTypeInfo.get("Int64")], ["hello"]))
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.StaticFuncAnnotation")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []) == ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []) != ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []) == ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("annotatedMethod", []) != ClassTypeInfo.get("upstream.AnnotatedStaticFuncClass").getStaticFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]), true)
    }

}

