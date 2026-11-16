/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-20
 * - @TestCaseName: std.reflect — ClassTypeInfo — OpenClass
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Open class with inheritance (Animal → Dog)
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
        @Expect[anyValue](Animal(), ClassTypeInfo.of(Animal()).construct([]))
        @Expect[anyValue](Animal("hello"), ClassTypeInfo.of(Animal()).construct(["hello"]))
        @Expect(ClassTypeInfo.of(Animal()).getConstructor([]).toString() != "", true)
        @Expect(ClassTypeInfo.of(Animal()).getConstructor([StructTypeInfo.get("std.core.String")]).toString() != "", true)
        @Expect[anyValue](Animal(), ClassTypeInfo.of(Animal()).getConstructor([]).apply([]))
        @Expect[anyValue](Animal("hello"), ClassTypeInfo.of(Animal()).getConstructor([StructTypeInfo.get("std.core.String")]).apply(["hello"]))
        @Expect(ClassTypeInfo.of(Animal()).constructors.toArray().size, 2i64)
        @Expect[annotations](ClassTypeInfo.of(Animal()).annotations, [])
        @Expect[annotations](ClassTypeInfo.of(Animal()).getConstructor([]).annotations, [])
        @Expect[annotations](ClassTypeInfo.of(Animal()).getConstructor([StructTypeInfo.get("std.core.String")]).annotations, [])
        @Expect(ClassTypeInfo.of(Animal()).instanceVariables.toArray().size, 1i64)
        @Expect(ClassTypeInfo.of(Animal()).getInstanceVariable("name").name != "")
        @Expect[anyValue](true, ClassTypeInfo.of(Animal()).getInstanceVariable("name").isMutable())
        @Expect[anyValue](ClassTypeInfo.of(Animal()).getInstanceVariable("name").setValue(ClassTypeInfo.of(Animal()).construct([]), "hello"), ClassTypeInfo.of(Animal()).getInstanceVariable("name").setValue(ClassTypeInfo.of(Animal()).construct([]), "hello"))
        @Expect(ClassTypeInfo.of(Animal()).staticVariables.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(Animal()).superClass.isSome(), true)
        @Expect(ClassTypeInfo.of(Animal()).isAbstract(), false)
        @Expect(ClassTypeInfo.of(Animal()).isOpen(), true)
        @Expect(ClassTypeInfo.of(Animal()).isSealed(), false)
        @Expect(ClassTypeInfo.of(Animal()).sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(Animal()).toString(), "upstream.Animal")
        @Expect(ClassTypeInfo.of(Animal()).hashCode() == ClassTypeInfo.of(Animal()).hashCode(), true)
        @Expect(ClassTypeInfo.of(Animal()).qualifiedName, "upstream.Animal")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of(Animal()).getInstanceVariable("__NonExistentVar__"))
    }
}
