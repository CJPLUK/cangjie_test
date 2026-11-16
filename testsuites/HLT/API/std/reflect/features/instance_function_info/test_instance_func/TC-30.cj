/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-30
*- @TestCaseName: std.reflect — InstanceFunctionInfo — OverloadFuncClass × valid × fromGetInstanceFunction
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
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).name, "process")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).toString(), "func process(): Int64")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).hashCode() == ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).apply(OverloadFuncClass(), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []).apply(OverloadFuncClass(), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).name, "process")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).toString(), "func process(Int64): Int64")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).hashCode() == ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).apply(OverloadFuncClass(), [1i64])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]).apply(OverloadFuncClass(), [PrimitiveTypeInfo.get("Int64")], [1i64]))
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).name, "process")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).toString(), "func process(String): String")
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).hashCode() == ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).findAllAnnotations<FuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).findAnnotation<FuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).apply(OverloadFuncClass(), ["hello"])).name == "String")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [StructTypeInfo.get("std.core.String")]).apply(OverloadFuncClass(), [PrimitiveTypeInfo.get("Int64")], ["hello"]))
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []) == ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []), true)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []) != ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []) == ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]), false)
        @Expect(ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", []) != ClassTypeInfo.get("upstream.OverloadFuncClass").getInstanceFunction("process", [PrimitiveTypeInfo.get("Int64")]), true)
    }

}

