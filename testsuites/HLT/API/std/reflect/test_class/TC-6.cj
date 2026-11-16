/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-6
 * - @TestCaseName: std.reflect — ClassTypeInfo — MultiCtorClass
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Class with 4 constructors (0/1/3/4 params)
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
        @Expect[anyValue](MultiCtorClass(), ClassTypeInfo.get("upstream.MultiCtorClass").construct([]))
        @Expect[anyValue](MultiCtorClass("hello"), ClassTypeInfo.get("upstream.MultiCtorClass").construct(["hello"]))
        @Expect[anyValue](MultiCtorClass("hello", 1i64, 1i64), ClassTypeInfo.get("upstream.MultiCtorClass").construct(["hello", 1i64, 1i64]))
        @Expect[anyValue](MultiCtorClass("hello", 1i64, 1i64, true), ClassTypeInfo.get("upstream.MultiCtorClass").construct(["hello", 1i64, 1i64, true]))
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([]).toString() != "", true)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).toString() != "", true)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).toString() != "", true)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Bool")]).toString() != "", true)
        @Expect[anyValue](MultiCtorClass(), ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([]).apply([]))
        @Expect[anyValue](MultiCtorClass("hello"), ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).apply(["hello"]))
        @Expect[anyValue](MultiCtorClass("hello", 1i64, 1i64), ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).apply(["hello", 1i64, 1i64]))
        @Expect[anyValue](MultiCtorClass("hello", 1i64, 1i64, true), ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Bool")]).apply(["hello", 1i64, 1i64, true]))
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").constructors.toArray().size, 4i64)
        @Expect[annotations](ClassTypeInfo.get("upstream.MultiCtorClass").annotations, [])
        @Expect[annotations](ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([]).annotations, [])
        @Expect[annotations](ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).annotations, [])
        @Expect[annotations](ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64")]).annotations, [])
        @Expect[annotations](ClassTypeInfo.get("upstream.MultiCtorClass").getConstructor([StructTypeInfo.get("std.core.String"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Int64"), PrimitiveTypeInfo.get("Bool")]).annotations, [])
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").instanceVariables.toArray().size, 4i64)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("name").name != "")
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("length").name != "")
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("width").name != "")
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("flag").name != "")
        @Expect[anyValue](true, ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("name").isMutable())
        @Expect[anyValue](true, ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("length").isMutable())
        @Expect[anyValue](true, ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("width").isMutable())
        @Expect[anyValue](true, ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("flag").isMutable())
        @Expect[anyValue](ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("name").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), "hello"), ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("name").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), "hello"))
        @Expect[anyValue](ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("length").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), 1i64), ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("length").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), 1i64))
        @Expect[anyValue](ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("width").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), 1i64), ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("width").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), 1i64))
        @Expect[anyValue](ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("flag").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), true), ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("flag").setValue(ClassTypeInfo.get("upstream.MultiCtorClass").construct([]), true))
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").staticVariables.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").superClass.isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").isSealed(), false)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").toString(), "upstream.MultiCtorClass")
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").hashCode() == ClassTypeInfo.get("upstream.MultiCtorClass").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.MultiCtorClass").qualifiedName, "upstream.MultiCtorClass")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.get("upstream.MultiCtorClass").getInstanceVariable("__NonExistentVar__"))
    }
}
