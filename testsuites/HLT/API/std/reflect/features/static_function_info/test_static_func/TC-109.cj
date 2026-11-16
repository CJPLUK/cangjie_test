/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-109
*- @TestCaseName: std.reflect — StaticFunctionInfo — StructStaticFunc × valid × fromGetStaticFunction
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 StaticFunctionInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 StaticFunctionInfo 引用（getStaticFunction / staticFunctions / getStaticFunctions）
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
class TestStaticFunc {
    @TestCase
    func testCase0(): Unit {
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).name, "sfGetValue")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).parameters.size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).modifiers.toArray().size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).returnType.name, "Int64")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).toString(), "static func sfGetValue(): Int64")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).hashCode() == StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).hashCode(), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).getAllAnnotations().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).apply(StructTypeInfo.get("upstream.StructStaticFuncShape"), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []).apply(StructTypeInfo.get("upstream.StructStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).name, "sfDouble")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).parameters.size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).modifiers.toArray().size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).returnType.name, "Int64")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).toString(), "static func sfDouble(Int64): Int64")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).hashCode() == StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).hashCode(), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).getAllAnnotations().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).apply(StructTypeInfo.get("upstream.StructStaticFuncShape"), [1i64])).name == "Int64")
        @ExpectThrows[InvocationTargetException](StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]).apply(StructTypeInfo.get("upstream.StructStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], [1i64]))
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).name, "sfGreet")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).parameters.size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).modifiers.toArray().size, 1i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).returnType.name, "String")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).toString(), "static func sfGreet(String): String")
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).hashCode() == StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 0i64)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).apply(StructTypeInfo.get("upstream.StructStaticFuncShape"), ["hello"])).name == "String")
        @ExpectThrows[InvocationTargetException](StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGreet", [StructTypeInfo.get("std.core.String")]).apply(StructTypeInfo.get("upstream.StructStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], ["hello"]))
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []) == StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []), true)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []) != StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []), false)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []) == StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]), false)
        @Expect(StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfGetValue", []) != StructTypeInfo.get("upstream.StructStaticFuncShape").getStaticFunction("sfDouble", [PrimitiveTypeInfo.get("Int64")]), true)
    }

}

