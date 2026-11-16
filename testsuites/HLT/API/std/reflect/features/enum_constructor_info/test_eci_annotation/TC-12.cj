/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-12
*- @TestCaseName: std.reflect — EnumConstructorInfo (注解形态) — Ctor_EciAnn_C4
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciAnn_C4（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测枚举已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 EnumConstructorInfo
*   -#按 Rule 预言验证属性/构造/拆解/注解/相等行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方文档契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: upstream ../../../utils
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// (!target_ohos) EXEC: %compiler %cmp_opt %f -L . -lupstream -lutils -o %output %cmp_utest_opt
// (!target_ohos) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import upstream.*
import std.collection.*
import utils.*
@Test
class TestEciAnnotation {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").qualifiedName == "upstream.EciAnn.C4(String)", true)
        @Expect(EnumConstructorInfo.of(EciAnn.C4("a")) == EnumConstructorInfo.get("upstream.EciAnn.C4(String)"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").name, "C4")
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").qualifiedName, "upstream.EciAnn.C4(String)")
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").enumTypeInfo.qualifiedName, "upstream.EciAnn")
        @Expect[parameterTypeNames](EnumConstructorInfo.get("upstream.EciAnn.C4(String)").parameters, ["String"])
        @Expect(EnumConstructorInfo.of(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").apply(["a"])) == EnumConstructorInfo.get("upstream.EciAnn.C4(String)"), true)
        @Expect[anyList](EnumConstructorInfo.get("upstream.EciAnn.C4(String)").getAssociatedValues(EciAnn.C4("a")), ["a"])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciAnn.C4(String)").annotations, [CTag("hello")])
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").findAnnotation<CTag>().isSome(), true)
        @Expect[annotationsArray](EnumConstructorInfo.get("upstream.EciAnn.C4(String)").findAllAnnotations<CTag>(), ["CTag"])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciAnn.C4(String)").getAllAnnotations(), [CTag("hello")])
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").hashCode() == EnumConstructorInfo.get("upstream.EciAnn.C4(String)").hashCode(), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)").toString() == EnumConstructorInfo.get("upstream.EciAnn.C4(String)").qualifiedName, true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)") == EnumConstructorInfo.get("upstream.EciAnn.C4(String)"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)") == EnumTypeInfo.get("upstream.EciAnn").getConstructor("C1", argsCount: 0i64), false)
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)") != EnumTypeInfo.get("upstream.EciAnn").getConstructor("C1", argsCount: 0i64), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnn.C4(String)") != EnumConstructorInfo.get("upstream.EciAnn.C4(String)"), false)
    }

}

