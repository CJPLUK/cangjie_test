/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-59
*- @TestCaseName: std.reflect — InstanceFunctionInfo — OpenFuncClass × valid × fromGetInstanceFunction
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
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).name, "hook")
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).returnType.name, "Unit")
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).toString(), "open func hook(): Unit")
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).hashCode() == ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).isOpen(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).apply(OpenFuncShape(), [])).name == "Unit")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []).apply(OpenFuncShape(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).name, "plain")
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).toString(), "func plain(): Int64")
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).hashCode() == ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).apply(OpenFuncShape(), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []).apply(OpenFuncShape(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []) == ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []), true)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []) != ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []), false)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []) == ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []), false)
        @Expect(ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("hook", []) != ClassTypeInfo.get("upstream.OpenFuncShape").getInstanceFunction("plain", []), true)
    }

}

