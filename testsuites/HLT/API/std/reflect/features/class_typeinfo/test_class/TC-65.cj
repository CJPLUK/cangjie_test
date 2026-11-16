/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-65
*- @TestCaseName: std.reflect — ClassTypeInfo — OpenClass × missingStaticVar × getByName
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 ClassTypeInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 ClassTypeInfo 引用（get/of/of<T>）
*   -#通过 Rule 预言验证各 API 的返回结果或异常路径
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
class TestClassCase {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.Animal").toString(), "upstream.Animal")
        @Expect[anyValue](ClassTypeInfo.get("upstream.Animal").construct([]), Animal())
        @Expect(ClassTypeInfo.get("upstream.Animal").getConstructor([]).toString() != "")
        @Expect(ClassTypeInfo.get("upstream.Animal").getInstanceVariable("name").toString() != "")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.get("upstream.Animal").getStaticVariable("name"))
        @Expect(ClassTypeInfo.get("upstream.Animal").isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.Animal").isOpen(), true)
        @Expect(ClassTypeInfo.get("upstream.Animal").isSealed(), false)
        @Expect(ClassTypeInfo.get("upstream.Animal").sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.Animal").superClass.isSome(), true)
        @Expect(ClassTypeInfo.get("upstream.Animal").constructors.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.Animal").instanceVariables.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.Animal").staticVariables.toArray().size, 0i64)
    }

}

