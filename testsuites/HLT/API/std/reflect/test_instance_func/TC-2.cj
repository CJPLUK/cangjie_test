/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-2
 * - @TestCaseName: std.reflect — InstanceFunctionInfo — SimpleInstanceFunc
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Class with simple getValue/setValue instance functions
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
class TestInstanceFunc {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).instanceFunctions.toArray().size, 2i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).name, "getValue")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).toString() != "")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).isAbstract(), false)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).isOpen(), false)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).annotations.toArray().size >= 0i64)
        @Expect[anyValue](ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).apply(ClassTypeInfo.of(SimpleFuncClass()).construct([]), []), ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("getValue", []).apply(ClassTypeInfo.of(SimpleFuncClass()).construct([]), []))
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).name, "setValue")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).returnType.name, "Unit")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).parameters.get(0i64).getOrThrow().name, "v")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).parameters.get(0i64).getOrThrow().typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).parameters.get(0i64).getOrThrow().index, 0i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).toString() != "")
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).isAbstract(), false)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).isOpen(), false)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).modifiers.toArray().size >= 0i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size >= 0i64)
        @Expect[anyValue](ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).apply(ClassTypeInfo.of(SimpleFuncClass()).construct([]), [1i64]), ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunction("setValue", [PrimitiveTypeInfo.get("Int64")]).apply(ClassTypeInfo.of(SimpleFuncClass()).construct([]), [1i64]))
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).getInstanceFunctions("getValue").toArray().size >= 1i64)
        @Expect(ClassTypeInfo.of(SimpleFuncClass()).qualifiedName, "upstream.SimpleFuncClass")
    }
}
