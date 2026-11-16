/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-49
*- @TestCaseName: std.reflect — ClassTypeInfo — RichMemberClass × missingStaticVar × ofInstance
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
        @Expect(ClassTypeInfo.of(RichMemberClass()).toString(), "upstream.RichMemberClass")
        @Expect[anyValue](ClassTypeInfo.of(RichMemberClass()).construct([]), RichMemberClass())
        @Expect(ClassTypeInfo.of(RichMemberClass()).getConstructor([]).toString() != "")
        @Expect(ClassTypeInfo.of(RichMemberClass()).getInstanceVariable("counter").toString() != "")
        @ExpectThrows[InfoNotFoundException](ClassTypeInfo.of(RichMemberClass()).getStaticVariable("counter"))
        @Expect(ClassTypeInfo.of(RichMemberClass()).isAbstract(), false)
        @Expect(ClassTypeInfo.of(RichMemberClass()).isOpen(), false)
        @Expect(ClassTypeInfo.of(RichMemberClass()).isSealed(), false)
        @Expect(ClassTypeInfo.of(RichMemberClass()).sealedSubclasses.toArray().size, 0i64)
        @Expect(ClassTypeInfo.of(RichMemberClass()).superClass.isSome(), true)
        @Expect(ClassTypeInfo.of(RichMemberClass()).constructors.toArray().size, 1i64)
        @Expect(ClassTypeInfo.of(RichMemberClass()).instanceVariables.toArray().size, 2i64)
        @Expect(ClassTypeInfo.of(RichMemberClass()).staticVariables.toArray().size, 2i64)
    }

}

