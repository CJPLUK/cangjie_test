/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-4
 * - @TestCaseName: std.reflect — StructTypeInfo — SimpleStruct
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Simple struct with public vars
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
        @Expect(StructTypeInfo.of<SimpleStruct>().name != "")
        @Expect[anyValue](StructTypeInfo.of<SimpleStruct>().toString(), StructTypeInfo.of<SimpleStruct>().qualifiedName)
        @Expect(StructTypeInfo.of<SimpleStruct>().constructors.toArray().size, 1i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().getConstructor([]).toString() != "")
        @Expect[anyValue](StructTypeInfo.of<SimpleStruct>().getConstructor([]).apply([]), StructTypeInfo.of<SimpleStruct>().getConstructor([]).apply([]))
        @Expect(StructTypeInfo.of<SimpleStruct>().instanceVariables.toArray().size, 3i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().getInstanceVariable("x").name, "x")
        @Expect(StructTypeInfo.of<SimpleStruct>().getInstanceVariable("x").isMutable(), true)
        @Expect(StructTypeInfo.of<SimpleStruct>().getInstanceVariable("y").name, "y")
        @Expect(StructTypeInfo.of<SimpleStruct>().getInstanceVariable("y").isMutable(), true)
        @Expect(StructTypeInfo.of<SimpleStruct>().getInstanceVariable("label").name, "label")
        @Expect(StructTypeInfo.of<SimpleStruct>().getInstanceVariable("label").isMutable(), false)
        @Expect(StructTypeInfo.of<SimpleStruct>().staticVariables.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().instanceFunctions.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().staticFunctions.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().instanceProperties.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().staticProperties.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<SimpleStruct>().hashCode() == StructTypeInfo.of<SimpleStruct>().hashCode())
        @Expect(StructTypeInfo.of<SimpleStruct>() == StructTypeInfo.get("upstream.SimpleStruct"))
        @ExpectThrows[InfoNotFoundException](StructTypeInfo.get("std.core.Int64"))
        @Expect(StructTypeInfo.of<SimpleStruct>().qualifiedName, "upstream.SimpleStruct")
        @ExpectThrows[InfoNotFoundException](StructTypeInfo.of<SimpleStruct>().construct([0i64, 0i64, 0i64]))
    }
}
