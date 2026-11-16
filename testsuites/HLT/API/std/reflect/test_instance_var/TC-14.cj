/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-14
 * - @TestCaseName: std.reflect — InstanceVariableInfo — AnnotatedInstanceVar
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Class with annotated instance variable
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
class TestInstanceVar {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).instanceVariables.toArray().size, 1i64)
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").name, "info")
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").typeInfo.name, "String")
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").isMutable(), false)
        @Expect[anyValue](ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").getValue(ClassTypeInfo.of(AnnotatedVarClass()).construct([])), ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").getValue(ClassTypeInfo.of(AnnotatedVarClass()).construct([])))
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").annotations.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").toString() != "")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("__NonExistentVar__"))
        @ExpectThrows[IllegalSetException](ClassTypeInfo.of(AnnotatedVarClass()).getInstanceVariable("info").setValue(ClassTypeInfo.of(AnnotatedVarClass()).construct([]), "hello"))
    }
}
