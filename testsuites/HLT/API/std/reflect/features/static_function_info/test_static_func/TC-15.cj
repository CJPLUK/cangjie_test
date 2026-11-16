/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-15
*- @TestCaseName: std.reflect — StaticFunctionInfo — MultiStaticFuncClass × valid × fromGetStaticFunction
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
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).name, "sfAdd")
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).toString(), "static func sfAdd(Int64, Int64): Int64")
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).hashCode() == ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply(ClassTypeInfo.get("upstream.MultiStaticFuncShape"), [1i64, 1i64])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply(ClassTypeInfo.get("upstream.MultiStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], [1i64, 1i64]))
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).name, "sfConcat")
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).toString(), "static func sfConcat(String, String): String")
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).hashCode() == ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).apply(ClassTypeInfo.get("upstream.MultiStaticFuncShape"), ["hello", "hello"])).name == "String")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).apply(ClassTypeInfo.get("upstream.MultiStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], ["hello", "hello"]))
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]) == ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]), true)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]) != ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]), false)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]) == ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]), false)
        @Expect(ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfAdd", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]) != ClassTypeInfo.get("upstream.MultiStaticFuncShape").getStaticFunction("sfConcat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]), true)
    }

}

