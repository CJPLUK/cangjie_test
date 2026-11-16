/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-59
*- @TestCaseName: std.reflect — StaticFunctionInfo — ThrowingStaticFuncClass × valid × fromGetStaticFunctions
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
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().name, "fail")
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().toString(), "static func fail(): Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().hashCode() == ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().genericParams.toArray().size, 0i64)
        @ExpectThrows[Exception](ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().apply(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape"), []))
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow().apply(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().name, "ok")
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().returnType.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().toString(), "static func ok(): Int64")
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().hashCode() == ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().findAllAnnotations<StaticFuncAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().findAnnotation<StaticFuncAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().genericParams.toArray().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().apply(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape"), [])).name == "Int64")
        @ExpectThrows[InvocationTargetException](ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow().apply(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape"), [PrimitiveTypeInfo.get("Int64")], []))
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow() == ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow() != ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow(), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow() == ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow(), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("fail").get(0i64).getOrThrow() != ClassTypeInfo.get("upstream.ThrowingStaticFuncShape").getStaticFunctions("ok").get(0i64).getOrThrow(), true)
    }

}

