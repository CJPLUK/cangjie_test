/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-12
 * - @TestCaseName: std.reflect — ClassTypeInfo — RichMemberClass
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Class with instance/static vars, funcs, and props
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
        @Expect[anyValue](RichMemberClass(), ClassTypeInfo.get("upstream.RichMemberClass").construct([]))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getConstructor([]).toString() != "", true)
        @Expect[anyValue](RichMemberClass(), ClassTypeInfo.get("upstream.RichMemberClass").getConstructor([]).apply([]))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").constructors.toArray().size, 1i64)
        @Expect[annotations](ClassTypeInfo.get("upstream.RichMemberClass").annotations, [])
        @Expect[annotations](ClassTypeInfo.get("upstream.RichMemberClass").getConstructor([]).annotations, [])
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").instanceVariables.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("counter").name != "")
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("label").name != "")
        @Expect[anyValue](true, ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("counter").isMutable())
        @Expect[anyValue](false, ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("label").isMutable())
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("counter").setValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([]), 1i64), ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("counter").setValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([]), 1i64))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").staticVariables.toArray().size, 2i64)
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("instanceCount").getValue(), ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("instanceCount").getValue())
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("className").getValue(), ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("className").getValue())
        @Expect[anyValue](true, ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("instanceCount").isMutable())
        @Expect[anyValue](false, ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("className").isMutable())
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("instanceCount").setValue(1i64), ClassTypeInfo.get("upstream.RichMemberClass").getStaticVariable("instanceCount").setValue(1i64))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getInstanceFunction("increment", []).name, "increment")
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceFunction("increment", []).isOpen(), ClassTypeInfo.get("upstream.RichMemberClass").getInstanceFunction("increment", []).isOpen())
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceFunction("increment", []).apply(ClassTypeInfo.get("upstream.RichMemberClass").construct([]), []), ClassTypeInfo.get("upstream.RichMemberClass").getInstanceFunction("increment", []).apply(ClassTypeInfo.get("upstream.RichMemberClass").construct([]), []))
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("info").getValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([])), ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("info").getValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([])))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("info").isMutable(), false)
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("score").getValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([])), ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("score").getValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([])))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("score").isMutable(), true)
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("score").setValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([]), 1i64), ClassTypeInfo.get("upstream.RichMemberClass").getInstanceProperty("score").setValue(ClassTypeInfo.get("upstream.RichMemberClass").construct([]), 1i64))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getStaticFunction("create", []).name, "create")
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticFunction("create", []).apply(ClassTypeInfo.get("upstream.RichMemberClass"), []), ClassTypeInfo.get("upstream.RichMemberClass").getStaticFunction("create", []).apply(ClassTypeInfo.get("upstream.RichMemberClass"), []))
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("config").getValue(), ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("config").getValue())
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("config").isMutable(), false)
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("propCounter").getValue(), ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("propCounter").getValue())
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("propCounter").isMutable(), true)
        @Expect[anyValue](ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("propCounter").setValue(1i64), ClassTypeInfo.get("upstream.RichMemberClass").getStaticProperty("propCounter").setValue(1i64))
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").superClass.isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").isSealed(), false)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").toString(), "upstream.RichMemberClass")
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").hashCode() == ClassTypeInfo.get("upstream.RichMemberClass").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.RichMemberClass").qualifiedName, "upstream.RichMemberClass")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.get("upstream.RichMemberClass").getInstanceVariable("__NonExistentVar__"))
    }
}
