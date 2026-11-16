/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-4
 * - @TestCaseName: std.reflect — StaticVariableInfo — SimpleStaticVar
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Class with simple static variables (immutable + mutable)
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
class TestStaticVar {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().staticVariables.toArray().size, 2i64)
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").name, "appName")
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").typeInfo.name, "String")
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").isMutable(), false)
        @Expect[anyValue](ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").getValue(), ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").getValue())
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").annotations.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("appName").toString() != "")
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").name, "counter")
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").isMutable(), true)
        @Expect[anyValue](ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").getValue(), ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").getValue())
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").annotations.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").toString() != "")
        @Expect[anyValue](ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").setValue(1i64), ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("counter").setValue(1i64))
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of<SimpleStaticVarClass>().getStaticVariable("__NonExistentStaticVar__"))
    }
}
