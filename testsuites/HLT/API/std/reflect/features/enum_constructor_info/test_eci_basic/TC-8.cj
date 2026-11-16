/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-8
*- @TestCaseName: std.reflect — EnumConstructorInfo (基本形态) — Ctor_EciE_B3
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciE_B3（typeVariant × acquisitionPath）
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
class TestEciBasic {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").qualifiedName == "upstream.EciE.B3(Int64, String)", true)
        @Expect(EnumConstructorInfo.of(EciE.B3(42, "hi")) == EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").name, "B3")
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").qualifiedName, "upstream.EciE.B3(Int64, String)")
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").enumTypeInfo.qualifiedName, "upstream.EciE")
        @Expect[parameterTypeNames](EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").parameters, ["Int64", "String"])
        @Expect(EnumConstructorInfo.of(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").apply([42, "hi"])) == EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)"), true)
        @Expect[anyList](EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").getAssociatedValues(EciE.B3(42, "hi")), [42, "hi"])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").annotations, [])
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").findAllAnnotations<Tag>(), [])
        @Expect[annotations](EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").getAllAnnotations(), [])
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").hashCode() == EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").hashCode(), true)
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").toString() == EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)").qualifiedName, true)
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)") == EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)"), true)
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)") == EnumTypeInfo.get("upstream.EciE").getConstructor("B1", argsCount: 0i64), false)
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)") != EnumTypeInfo.get("upstream.EciE").getConstructor("B1", argsCount: 0i64), true)
        @Expect(EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)") != EnumConstructorInfo.get("upstream.EciE.B3(Int64, String)"), false)
    }

}

