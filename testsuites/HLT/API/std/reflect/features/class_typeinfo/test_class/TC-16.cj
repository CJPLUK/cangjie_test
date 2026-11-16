/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-16
*- @TestCaseName: std.reflect — ClassTypeInfo — SimpleClass × missingStaticVar × ofTypeArg
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
        @Expect(ClassTypeInfo.of<SimpleClass>().toString(), "upstream.SimpleClass")
        @Expect[anyValue](ClassTypeInfo.of<SimpleClass>().construct([]), SimpleClass())
        @Expect(ClassTypeInfo.of<SimpleClass>().getConstructor([]).toString() != "")
        @Expect(ClassTypeInfo.of<SimpleClass>().getInstanceVariable("name").toString() != "")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of<SimpleClass>().getStaticVariable("name"))
        @Expect(ClassTypeInfo.of<SimpleClass>().isAbstract(), false)
        @Expect(ClassTypeInfo.of<SimpleClass>().isOpen(), false)
        @Expect(ClassTypeInfo.of<SimpleClass>().isSealed(), false)
        @Expect(ClassTypeInfo.of<SimpleClass>().sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of<SimpleClass>().superClass.isSome(), true)
        @Expect(ClassTypeInfo.of<SimpleClass>().constructors.toArray().size, 1i64)
        @Expect(ClassTypeInfo.of<SimpleClass>().instanceVariables.toArray().size, 2i64)
        @Expect(ClassTypeInfo.of<SimpleClass>().staticVariables.toArray().size, 0i64)
    }

}

