/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — ConstructorInfo — SimpleCtorClass × fromGetConstructor
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
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).parameters.size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).toString(), "init()")
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).hashCode() == ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).hashCode(), true)
        @Expect[anyValue](TypeInfo.of(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).apply([])).qualifiedName, "upstream.SimpleCtorClass")
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).findAllAnnotations<CtorAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).findAnnotation<CtorAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).parameters.size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).toString(), "init(String)")
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).hashCode() == ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).hashCode(), true)
        @Expect[anyValue](TypeInfo.of(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).apply(["hello"])).qualifiedName, "upstream.SimpleCtorClass")
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).findAllAnnotations<CtorAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).findAnnotation<CtorAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).getAllAnnotations().size, 0i64)
        @ExpectThrows[IllegalTypeException](ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]).apply([1i64]))
        @ExpectThrows[IllegalArgumentException](ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]).apply([1i64]))
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]) == ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]), true)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]) != ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]), false)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]) == ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]), false)
        @Expect(ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([]) != ClassTypeInfo.get("upstream.SimpleCtorClass").getConstructor([StructTypeInfo.get("std.core.String")]), true)
    }

}

