/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — EnumConstructorInfo (跨枚举同名形态) — Ctor_EciPeer_W
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciPeer_W（typeVariant × acquisitionPath）
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

// LEVEL: 0
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
class TestEciCross {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").qualifiedName == "upstream.EciPeer.W(Int64)", true)
        @Expect(EnumConstructorInfo.of(EciPeer.W(1)) == EnumConstructorInfo.get("upstream.EciPeer.W(Int64)"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").name, "W")
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").qualifiedName, "upstream.EciPeer.W(Int64)")
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").enumTypeInfo.qualifiedName, "upstream.EciPeer")
        @Expect[parameterTypeNames](EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").parameters, ["Int64"])
        @Expect(EnumConstructorInfo.of(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").apply([1])) == EnumConstructorInfo.get("upstream.EciPeer.W(Int64)"), true)
        @Expect[anyList](EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").getAssociatedValues(EciPeer.W(1)), [1])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").annotations, [])
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").findAllAnnotations<Tag>(), [])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").getAllAnnotations(), [])
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").hashCode() == EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").hashCode(), true)
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").toString() == EnumConstructorInfo.get("upstream.EciPeer.W(Int64)").qualifiedName, true)
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)") == EnumConstructorInfo.get("upstream.EciPeer.W(Int64)"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)") == EnumTypeInfo.get("upstream.EciPeer2").getConstructor("W", argsCount: 1i64), false)
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)") != EnumTypeInfo.get("upstream.EciPeer2").getConstructor("W", argsCount: 1i64), true)
        @Expect(EnumConstructorInfo.get("upstream.EciPeer.W(Int64)") != EnumConstructorInfo.get("upstream.EciPeer.W(Int64)"), false)
    }

}

