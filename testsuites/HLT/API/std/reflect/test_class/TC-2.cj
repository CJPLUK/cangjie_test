/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-2
 * - @TestCaseName: std.reflect — ClassTypeInfo — SimpleClass
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Simple class: no-arg ctor + public mutable vars
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
class TestClassCase {
    @TestCase
    func testCase0(): Unit {
        @Expect[anyValue](SimpleClass(), ClassTypeInfo.of(SimpleClass()).construct([]))
        @Expect(ClassTypeInfo.of(SimpleClass()).getConstructor([]).toString() != "", true)
        @Expect[anyValue](SimpleClass(), ClassTypeInfo.of(SimpleClass()).getConstructor([]).apply([]))
        @Expect(ClassTypeInfo.of(SimpleClass()).constructors.toArray().size, 1i64)
        @Expect[annotations](ClassTypeInfo.of(SimpleClass()).annotations, [])
        @Expect[annotations](ClassTypeInfo.of(SimpleClass()).getConstructor([]).annotations, [])
        @Expect(ClassTypeInfo.of(SimpleClass()).instanceVariables.toArray().size, 2i64)
        @Expect(ClassTypeInfo.of(SimpleClass()).getInstanceVariable("name").name != "")
        @Expect(ClassTypeInfo.of(SimpleClass()).getInstanceVariable("value").name != "")
        @Expect[anyValue](true, ClassTypeInfo.of(SimpleClass()).getInstanceVariable("name").isMutable())
        @Expect[anyValue](true, ClassTypeInfo.of(SimpleClass()).getInstanceVariable("value").isMutable())
        @Expect[anyValue](ClassTypeInfo.of(SimpleClass()).getInstanceVariable("name").setValue(ClassTypeInfo.of(SimpleClass()).construct([]), "hello"), ClassTypeInfo.of(SimpleClass()).getInstanceVariable("name").setValue(ClassTypeInfo.of(SimpleClass()).construct([]), "hello"))
        @Expect[anyValue](ClassTypeInfo.of(SimpleClass()).getInstanceVariable("value").setValue(ClassTypeInfo.of(SimpleClass()).construct([]), 1i64), ClassTypeInfo.of(SimpleClass()).getInstanceVariable("value").setValue(ClassTypeInfo.of(SimpleClass()).construct([]), 1i64))
        @Expect(ClassTypeInfo.of(SimpleClass()).staticVariables.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(SimpleClass()).superClass.isSome(), true)
        @Expect(ClassTypeInfo.of(SimpleClass()).isAbstract(), false)
        @Expect(ClassTypeInfo.of(SimpleClass()).isOpen(), false)
        @Expect(ClassTypeInfo.of(SimpleClass()).isSealed(), false)
        @Expect(ClassTypeInfo.of(SimpleClass()).sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(SimpleClass()).toString(), "upstream.SimpleClass")
        @Expect(ClassTypeInfo.of(SimpleClass()).hashCode() == ClassTypeInfo.of(SimpleClass()).hashCode(), true)
        @Expect(ClassTypeInfo.of(SimpleClass()).qualifiedName, "upstream.SimpleClass")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of(SimpleClass()).getInstanceVariable("__NonExistentVar__"))
    }
}
