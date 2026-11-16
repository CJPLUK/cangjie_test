/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-149
*- @TestCaseName: std.reflect — InstanceFunctionInfo — StructFunc × valid × fromGetInstanceFunction
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
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).name, "getValue")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).parameters.size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).modifiers.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).returnType.name, "Int64")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).toString(), "func getValue(): Int64")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).hashCode() == StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).hashCode(), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).isAbstract(), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).isOpen(), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).getAllAnnotations().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).apply(StructFuncShape(), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []).apply(StructFuncShape(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).name, "echo")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).parameters.size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).modifiers.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).returnType.name, "Unit")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).toString(), "func echo(Int64): Unit")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).hashCode() == StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).hashCode(), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).isAbstract(), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).isOpen(), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).getAllAnnotations().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).apply(StructFuncShape(), [1i64])).name == "Unit")
        @ExpectThrows[InvocationTargetException](StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]).apply(StructFuncShape(), [PrimitiveTypeInfo.get("Int64")], [1i64]))
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).name, "greet")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).parameters.size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).modifiers.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).toString(), "func greet(String): String")
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).hashCode() == StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).isAbstract(), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).isOpen(), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).apply(StructFuncShape(), ["hello"])).name == "String")
        @ExpectThrows[InvocationTargetException](StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("greet", [StructTypeInfo.get("std.core.String")]).apply(StructFuncShape(), [PrimitiveTypeInfo.get("Int64")], ["hello"]))
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []) == StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []), true)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []) != StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []) == StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]), false)
        @Expect(StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("getValue", []) != StructTypeInfo.get("upstream.StructFuncShape").getInstanceFunction("echo", [PrimitiveTypeInfo.get("Int64")]), true)
    }

}

