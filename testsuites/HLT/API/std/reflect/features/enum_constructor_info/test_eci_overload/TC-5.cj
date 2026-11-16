/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-5
*- @TestCaseName: std.reflect — EnumConstructorInfo (重载形态) — Ctor_EciOvl_W
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciOvl_W（typeVariant × acquisitionPath）
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
class TestEciOverload {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumConstructorInfo.get("upstream.EciOvl.W(Int64, Int64)").qualifiedName == "upstream.EciOvl.W(Int64, Int64)", true)
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)) == EnumConstructorInfo.of(EciOvl.W(1, 2)), true)
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)).name, "W")
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)).qualifiedName, "upstream.EciOvl.W(Int64, Int64)")
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)).enumTypeInfo.qualifiedName, "upstream.EciOvl")
        @Expect[parameterTypeNames](EnumConstructorInfo.of(EciOvl.W(1, 2)).parameters, ["Int64", "Int64"])
        @Expect(EnumConstructorInfo.of(EnumConstructorInfo.of(EciOvl.W(1, 2)).apply([1, 2])) == EnumConstructorInfo.of(EciOvl.W(1, 2)), true)
        @Expect[anyList](EnumConstructorInfo.of(EciOvl.W(1, 2)).getAssociatedValues(EciOvl.W(1, 2)), [1, 2])
        @Expect[annotations](EnumConstructorInfo.of(EciOvl.W(1, 2)).annotations, [])
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](EnumConstructorInfo.of(EciOvl.W(1, 2)).findAllAnnotations<Tag>(), [])
        @Expect[annotations](EnumConstructorInfo.of(EciOvl.W(1, 2)).getAllAnnotations(), [])
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)).hashCode() == EnumConstructorInfo.of(EciOvl.W(1, 2)).hashCode(), true)
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)).toString() == EnumConstructorInfo.of(EciOvl.W(1, 2)).qualifiedName, true)
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)) == EnumTypeInfo.get("upstream.EciOvl").getConstructor("W", argsCount: 1i64), false)
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)) != EnumTypeInfo.get("upstream.EciOvl").getConstructor("W", argsCount: 1i64), true)
        @Expect(EnumConstructorInfo.of(EciOvl.W(1, 2)) != EnumConstructorInfo.of(EciOvl.W(1, 2)), false)
    }

}

