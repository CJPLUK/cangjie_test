/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-16
*- @TestCaseName: std.reflect — EnumConstructorInfo (注解形态) — Ctor_EciAnnT_T1
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciAnnT_T1（typeVariant × acquisitionPath）
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
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").qualifiedName == "upstream.EciAnnT.T1", true)
        @Expect(EnumConstructorInfo.of(EciAnnT.T1) == EnumConstructorInfo.get("upstream.EciAnnT.T1"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").name, "T1")
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").qualifiedName, "upstream.EciAnnT.T1")
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").enumTypeInfo.qualifiedName, "upstream.EciAnnT")
        @Expect[parameterTypeNames](EnumConstructorInfo.get("upstream.EciAnnT.T1").parameters, [])
        @Expect(EnumConstructorInfo.of(EnumConstructorInfo.get("upstream.EciAnnT.T1").apply([])) == EnumConstructorInfo.get("upstream.EciAnnT.T1"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").getAssociatedValues(EciAnnT.T1).toArray().size, 0i64)
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciAnnT.T1").annotations, [])
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](EnumConstructorInfo.get("upstream.EciAnnT.T1").findAllAnnotations<Tag>(), [])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciAnnT.T1").getAllAnnotations(), [])
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").hashCode() == EnumConstructorInfo.get("upstream.EciAnnT.T1").hashCode(), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1").toString() == EnumConstructorInfo.get("upstream.EciAnnT.T1").qualifiedName, true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1") == EnumConstructorInfo.get("upstream.EciAnnT.T1"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciAnnT.T1") != EnumConstructorInfo.get("upstream.EciAnnT.T1"), false)
    }

}

