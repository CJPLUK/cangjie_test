/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-16
 * - @TestCaseName: std.reflect — StructTypeInfo — RichMemberStruct
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Struct with instance/static vars and funcs
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
        @Expect(StructTypeInfo.of<RichMemberStruct>().name != "")
        @Expect[anyValue](StructTypeInfo.of<RichMemberStruct>().toString(), StructTypeInfo.of<RichMemberStruct>().qualifiedName)
        @Expect(StructTypeInfo.of<RichMemberStruct>().constructors.toArray().size, 1i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().getConstructor([]).toString() != "")
        @Expect[anyValue](StructTypeInfo.of<RichMemberStruct>().getConstructor([]).apply([]), StructTypeInfo.of<RichMemberStruct>().getConstructor([]).apply([]))
        @Expect(StructTypeInfo.of<RichMemberStruct>().instanceVariables.toArray().size, 2i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().getInstanceVariable("counter").name, "counter")
        @Expect(StructTypeInfo.of<RichMemberStruct>().getInstanceVariable("counter").isMutable(), true)
        @Expect(StructTypeInfo.of<RichMemberStruct>().getInstanceVariable("id").name, "id")
        @Expect(StructTypeInfo.of<RichMemberStruct>().getInstanceVariable("id").isMutable(), false)
        @Expect(StructTypeInfo.of<RichMemberStruct>().staticVariables.toArray().size, 2i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().getStaticVariable("instanceCount").name, "instanceCount")
        @Expect(StructTypeInfo.of<RichMemberStruct>().getStaticVariable("kind").name, "kind")
        @Expect(StructTypeInfo.of<RichMemberStruct>().instanceFunctions.toArray().size, 2i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().staticFunctions.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().instanceProperties.toArray().size, 1i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().staticProperties.toArray().size, 2i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.of<RichMemberStruct>().hashCode() == StructTypeInfo.of<RichMemberStruct>().hashCode())
        @Expect(StructTypeInfo.of<RichMemberStruct>() == StructTypeInfo.get("upstream.RichMemberStruct"))
        @ExpectThrows[InfoNotFoundException](StructTypeInfo.get("std.core.Int64"))
        @Expect(StructTypeInfo.of<RichMemberStruct>().qualifiedName, "upstream.RichMemberStruct")
        @ExpectThrows[InfoNotFoundException](StructTypeInfo.of<RichMemberStruct>().construct([0i64, 0i64, 0i64]))
    }
}
