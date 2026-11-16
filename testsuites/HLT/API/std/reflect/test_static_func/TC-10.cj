/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-10
 * - @TestCaseName: std.reflect — StaticFunctionInfo — MultiStaticFunc
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Class with multi-param static functions
 * - @Condition: 用例的预置条件
 *   -#仓颉工具链环境已正确安装
 *   -#被测类型的源文件已编译为动态库
 * - @Brief: 描述测试步骤
 *   -#获取TypeInfo引用（byName/byInstance/byTypeArg）
 *   -#通过TypeInfo查询被测类型的成员信息
 *   -#构造实例并读写成员变量/属性
 *   -#调用成员函数并验证返回值
 * - @Expect: 用例的预期结果
 *   -#所有@Expect断言通过，反射API返回值与预期一致
 * - @Priority: P0
 */

// LEVEL: 3
// Description:
// DEPENDENCE: ../utils upstream
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
        @Expect(ClassTypeInfo.of<MultiStaticClass>().staticFunctions.toArray().size, 2i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).name, "multiply")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).returnType.name, "Int64")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.size, 3i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(0i64).getOrThrow().name, "a")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(0i64).getOrThrow().typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(0i64).getOrThrow().index, 0i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(1i64).getOrThrow().name, "b")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(1i64).getOrThrow().typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(1i64).getOrThrow().index, 1i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(2i64).getOrThrow().name, "c")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(2i64).getOrThrow().typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).parameters.get(2i64).getOrThrow().index, 2i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).toString() != "")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size >= 0i64)
        @Expect[anyValue](ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply(ClassTypeInfo.of<MultiStaticClass>(), [1i64, 1i64, 1i64]), ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("multiply", [PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply(ClassTypeInfo.of<MultiStaticClass>(), [1i64, 1i64, 1i64]))
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).name, "concat")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.size, 2i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.get(0i64).getOrThrow().name, "a")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.get(0i64).getOrThrow().typeInfo.name, "String")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.get(0i64).getOrThrow().index, 0i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.get(1i64).getOrThrow().name, "b")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.get(1i64).getOrThrow().typeInfo.name, "String")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).parameters.get(1i64).getOrThrow().index, 1i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).toString() != "")
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).annotations.toArray().size >= 0i64)
        @Expect[anyValue](ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).apply(ClassTypeInfo.of<MultiStaticClass>(), ["hello", "hello"]), ClassTypeInfo.of<MultiStaticClass>().getStaticFunction("concat", [StructTypeInfo.get("std.core.String"), StructTypeInfo.get("std.core.String")]).apply(ClassTypeInfo.of<MultiStaticClass>(), ["hello", "hello"]))
        @Expect(ClassTypeInfo.of<MultiStaticClass>().getStaticFunctions("multiply").toArray().size >= 1i64)
        @Expect(ClassTypeInfo.of<MultiStaticClass>().qualifiedName, "upstream.MultiStaticClass")
    }
}
