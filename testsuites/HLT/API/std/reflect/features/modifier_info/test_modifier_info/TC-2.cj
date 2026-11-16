/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-2
*- @TestCaseName: std.reflect — ModifierInfo — ExplicitModifierClass × enumApi
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 ModifierInfo 枚举语义与 modifiers 集合语义
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#经被测类型的反射信息对象获取 modifiers 集合 / 直接引用 ModifierInfo 枚举值
*   -#通过 Rule 预言验证 toString/hashCode/==/!= 与 modifiers 集合的空集/元素/定义序/语义包含条款
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，反射API返回值与Rule预言一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: ../../../utils redefpkg upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p redefpkg
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %f -L . -lutils -lupstream -lredefpkg -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import utils.*
import upstream.*
import std.reflect.*
@Test
class TestModifierInfo {
    @TestCase
    func testCase0(): Unit {
        @Expect(ModifierInfo.Open.toString(), "open")
        @Expect(ModifierInfo.Open.hashCode() == ModifierInfo.Open.hashCode(), true)
        @Expect(ModifierInfo.Open.hashCode() == "open".hashCode(), true)
        @Expect(ModifierInfo.Override.toString(), "override")
        @Expect(ModifierInfo.Override.hashCode() == ModifierInfo.Override.hashCode(), true)
        @Expect(ModifierInfo.Override.hashCode() == "override".hashCode(), true)
        @Expect(ModifierInfo.Redef.toString(), "redef")
        @Expect(ModifierInfo.Redef.hashCode() == ModifierInfo.Redef.hashCode(), true)
        @Expect(ModifierInfo.Redef.hashCode() == "redef".hashCode(), true)
        @Expect(ModifierInfo.Abstract.toString(), "abstract")
        @Expect(ModifierInfo.Abstract.hashCode() == ModifierInfo.Abstract.hashCode(), true)
        @Expect(ModifierInfo.Abstract.hashCode() == "abstract".hashCode(), true)
        @Expect(ModifierInfo.Sealed.toString(), "sealed")
        @Expect(ModifierInfo.Sealed.hashCode() == ModifierInfo.Sealed.hashCode(), true)
        @Expect(ModifierInfo.Sealed.hashCode() == "sealed".hashCode(), true)
        @Expect(ModifierInfo.Mut.toString(), "mut")
        @Expect(ModifierInfo.Mut.hashCode() == ModifierInfo.Mut.hashCode(), true)
        @Expect(ModifierInfo.Mut.hashCode() == "mut".hashCode(), true)
        @Expect(ModifierInfo.Static.toString(), "static")
        @Expect(ModifierInfo.Static.hashCode() == ModifierInfo.Static.hashCode(), true)
        @Expect(ModifierInfo.Static.hashCode() == "static".hashCode(), true)
        @Expect(ModifierInfo.Open == ModifierInfo.Open, true)
        @Expect(ModifierInfo.Open != ModifierInfo.Open, false)
        @Expect(ModifierInfo.Open == ModifierInfo.Abstract, false)
        @Expect(ModifierInfo.Open != ModifierInfo.Abstract, true)
    }

}

