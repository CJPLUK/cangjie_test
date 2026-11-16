/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-98
*- @TestCaseName: std.reflect — InstanceFunctionInfo — ThrowingFuncClass × valid × fromGetInstanceFunction
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 InstanceFunctionInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 InstanceFunctionInfo 引用（getInstanceFunction / instanceFunctions / getInstanceFunctions）
*   -#通过 Rule 预言验证 name/parameters/returnType/modifiers/annotations/apply/相等性 的返回结果或异常路径
*- @Expect: 用例的预期结果
*   -#所有@Expect/@ExpectThrows断言通过，反射API返回值/异常与Rule预言一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: ../../../utils upstream
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
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).name, "fail")
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).toString(), "func fail(): Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).hashCode() == ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).genericParams.toArray().size, 0i64)
        @ExpectThrows[Exception](ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).apply(ThrowingFuncShape(), []))
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []).apply(ThrowingFuncShape(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).name, "ok")
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).toString(), "func ok(): Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).hashCode() == ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).apply(ThrowingFuncShape(), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []).apply(ThrowingFuncShape(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []) == ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []) != ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []) == ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("fail", []) != ClassTypeInfo.get("upstream.ThrowingFuncShape").getInstanceFunction("ok", []), true)
    }

}

