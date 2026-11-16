/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-13
*- @TestCaseName: std.reflect — EnumConstructorInfo (复合关联值形态) — Ctor_EciComp_U1
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciComp_U1（typeVariant × acquisitionPath）
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
class TestEciComposite {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumConstructorInfo.get("upstream.EciComp.U1(upstream.HelperC)").qualifiedName == "upstream.EciComp.U1(upstream.HelperC)", true)
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))) == EnumConstructorInfo.of(EciComp.U1(HelperC(3))), true)
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).name, "U1")
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).qualifiedName, "upstream.EciComp.U1(upstream.HelperC)")
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).enumTypeInfo.qualifiedName, "upstream.EciComp")
        @Expect[parameterTypeNames](EnumConstructorInfo.of(EciComp.U1(HelperC(3))).parameters, ["HelperC"])
        @Expect(EnumConstructorInfo.of(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).apply([HelperC(3)])) == EnumConstructorInfo.of(EciComp.U1(HelperC(3))), true)
        @Expect[anyList](EnumConstructorInfo.of(EciComp.U1(HelperC(3))).getAssociatedValues(EciComp.U1(HelperC(3))), [HelperC(3)])
        @Expect[annotations](EnumConstructorInfo.of(EciComp.U1(HelperC(3))).annotations, [])
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](EnumConstructorInfo.of(EciComp.U1(HelperC(3))).findAllAnnotations<Tag>(), [])
        @Expect[annotations](EnumConstructorInfo.of(EciComp.U1(HelperC(3))).getAllAnnotations(), [])
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).hashCode() == EnumConstructorInfo.of(EciComp.U1(HelperC(3))).hashCode(), true)
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))).toString() == EnumConstructorInfo.of(EciComp.U1(HelperC(3))).qualifiedName, true)
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))) == EnumTypeInfo.get("upstream.EciComp").getConstructor("T1", argsCount: 1i64), false)
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))) != EnumTypeInfo.get("upstream.EciComp").getConstructor("T1", argsCount: 1i64), true)
        @Expect(EnumConstructorInfo.of(EciComp.U1(HelperC(3))) != EnumConstructorInfo.of(EciComp.U1(HelperC(3))), false)
    }

}

