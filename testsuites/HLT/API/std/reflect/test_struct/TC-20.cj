/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-20
 * - @TestCaseName: std.reflect — StructTypeInfo — GenericStruct
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Generic struct GenericPair<T, U>
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
class TestStruct {
    @TestCase
    func testCase0(): Unit {
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().name != "")
        @Expect[anyValue](StructTypeInfo.of<GenericPair<Int64, Int64>>().toString(), StructTypeInfo.of<GenericPair<Int64, Int64>>().qualifiedName)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().constructors.toArray().size, 1i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().getConstructor([PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).toString() != "")
        @Expect[anyValue](StructTypeInfo.of<GenericPair<Int64, Int64>>().getConstructor([PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply([1i64, 1i64]), StructTypeInfo.of<GenericPair<Int64, Int64>>().getConstructor([PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply([1i64, 1i64]))
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().instanceVariables.toArray().size, 2i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().getInstanceVariable("first").name, "first")
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().getInstanceVariable("first").isMutable(), true)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().getInstanceVariable("second").name, "second")
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().getInstanceVariable("second").isMutable(), true)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().staticVariables.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().instanceFunctions.toArray().size, 2i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().staticFunctions.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().instanceProperties.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().staticProperties.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().hashCode() == StructTypeInfo.of<GenericPair<Int64, Int64>>().hashCode())
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>() == StructTypeInfo.of<GenericPair<Int64, Int64>>())
        @ExpectThrows[InfoNotFoundException](StructTypeInfo.get("std.core.Int64"))
        @Expect(StructTypeInfo.of<GenericPair<Int64, Int64>>().qualifiedName, "upstream.GenericPair<Int64, Int64>")
        @ExpectThrows[InfoNotFoundException](StructTypeInfo.of<GenericPair<Int64, Int64>>().construct([0i64, 0i64, 0i64]))
    }
}
