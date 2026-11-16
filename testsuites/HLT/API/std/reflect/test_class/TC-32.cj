/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-32
 * - @TestCaseName: std.reflect — ClassTypeInfo — GenericClass
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Generic class GenericBox<T> with type parameter
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
        @Expect[anyValue](GenericBox<Int64>(1i64), ClassTypeInfo.of(GenericBox<Int64>(1i64)).construct([1i64]))
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).getConstructor([PrimitiveTypeInfo.get("Int64")]).toString() != "", true)
        @Expect[anyValue](GenericBox<Int64>(1i64), ClassTypeInfo.of(GenericBox<Int64>(1i64)).getConstructor([PrimitiveTypeInfo.get("Int64")]).apply([1i64]))
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).constructors.toArray().size, 1i64)
        @Expect[annotations](ClassTypeInfo.of(GenericBox<Int64>(1i64)).annotations, [])
        @Expect[annotations](ClassTypeInfo.of(GenericBox<Int64>(1i64)).getConstructor([PrimitiveTypeInfo.get("Int64")]).annotations, [])
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).instanceVariables.toArray().size, 1i64)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceVariable("content").name != "")
        @Expect[anyValue](true, ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceVariable("content").isMutable())
        @Expect[anyValue](ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceVariable("content").setValue(ClassTypeInfo.of(GenericBox<Int64>(1i64)).construct([1i64]), 1i64), ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceVariable("content").setValue(ClassTypeInfo.of(GenericBox<Int64>(1i64)).construct([1i64]), 1i64))
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).staticVariables.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceFunction("getContent", []).name, "getContent")
        @Expect[anyValue](ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceFunction("getContent", []).isOpen(), ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceFunction("getContent", []).isOpen())
        @Expect[anyValue](ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceFunction("getContent", []).apply(ClassTypeInfo.of(GenericBox<Int64>(1i64)).construct([1i64]), []), ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceFunction("getContent", []).apply(ClassTypeInfo.of(GenericBox<Int64>(1i64)).construct([1i64]), []))
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).superClass.isSome(), true)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).isAbstract(), false)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).isOpen(), false)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).isSealed(), false)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).toString(), "upstream.GenericBox<Int64>")
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).hashCode() == ClassTypeInfo.of(GenericBox<Int64>(1i64)).hashCode(), true)
        @Expect(ClassTypeInfo.of(GenericBox<Int64>(1i64)).qualifiedName, "upstream.GenericBox<Int64>")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of(GenericBox<Int64>(1i64)).getInstanceVariable("__NonExistentVar__"))
    }
}
