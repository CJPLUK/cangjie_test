/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-11
*- @TestCaseName: std.reflect — ConstructorInfo — ThrowCtorClass × fromGetConstructor
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 ConstructorInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 ConstructorInfo 引用（ClassTypeInfo.constructors[i] / getConstructor）
*   -#通过 Rule 预言验证 parameters/annotations/apply/相等性 的返回结果或异常路径
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
class TestConstructor {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).toString(), "init()")
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).hashCode() == ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).hashCode(), true)
        @ExpectThrows[Exception](ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).apply([]))
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).findAllAnnotations<CtorAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).findAnnotation<CtorAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).toString(), "init(Int64)")
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).hashCode() == ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).hashCode(), true)
        @Expect[anyValue](TypeInfo.of(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).apply([1i64])).qualifiedName, "upstream.ThrowCtorClass")
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).findAllAnnotations<CtorAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).findAnnotation<CtorAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]) == ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]), true)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]) != ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]) == ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]), false)
        @Expect(ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([]) != ClassTypeInfo.get("upstream.ThrowCtorClass").getConstructor([PrimitiveTypeInfo.get("Int64")]), true)
    }

}

