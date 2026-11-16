/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-131
*- @TestCaseName: std.reflect — InstanceFunctionInfo — AnnotatedFuncClass × valid × fromGetInstanceFunction
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 InstanceFunctionInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 InstanceFunctionInfo 引用（getInstanceFunction / instanceFunctions / getInstanceFunctions）
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
class TestInstanceFunc {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).name, "annotatedMethod")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).annotations.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).toString(), "func annotatedMethod(): Int64")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).hashCode() == ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).findAllAnnotations<FuncAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).findAnnotation<FuncAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).getAllAnnotations().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).apply(AnnotatedFuncClass(), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).apply(AnnotatedFuncClass(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []).annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.FuncAnnotation")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).name, "multiAnnotatedMethod")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).toString(), "func multiAnnotatedMethod(String): String")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).hashCode() == ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).findAllAnnotations<FuncAnnotation>().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).findAnnotation<FuncAnnotation>().isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).apply(AnnotatedFuncClass(), ["hello"])).name == "String")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).apply(AnnotatedFuncClass(), [PrimitiveTypeInfo.get("Int64")], ["hello"]))
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]).annotations.toArray().get(0i64).getOrThrow()).qualifiedName, "upstream.FuncAnnotation")
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []) == ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []), true)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []) != ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []) == ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]), false)
        @Expect(ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("annotatedMethod", []) != ClassTypeInfo.get("upstream.AnnotatedFuncClass").getInstanceFunction("multiAnnotatedMethod", [StructTypeInfo.get("std.core.String")]), true)
    }

}

