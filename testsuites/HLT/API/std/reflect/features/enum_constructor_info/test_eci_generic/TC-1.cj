/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
*- @TestCaseName: std.reflect — EnumConstructorInfo (泛型形态) — Ctor_EciGen_G1
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Ctor_EciGen_G1（typeVariant × acquisitionPath）
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
class TestEciGeneric {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumConstructorInfo.get("upstream.EciGen<Int64>.G1").qualifiedName == "upstream.EciGen<Int64>.G1", true)
        @Expect(EnumConstructorInfo.of(EciGen<Int64>.G1) == EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64), true)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).name, "G1")
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).qualifiedName, "upstream.EciGen<Int64>.G1")
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).enumTypeInfo.qualifiedName, "upstream.EciGen<Int64>")
        @Expect[parameterTypeNames](EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).parameters, [])
        @Expect(EnumConstructorInfo.of(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).apply([])) == EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64), true)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).getAssociatedValues(EciGen<Int64>.G1).toArray().size, 0i64)
        @Expect[annotations](EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).annotations, [])
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).findAllAnnotations<Tag>(), [])
        @Expect[annotations](EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).getAllAnnotations(), [])
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).hashCode() == EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).hashCode(), true)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).toString() == EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64).qualifiedName, true)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64) == EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64), true)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64) == EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G2", argsCount: 1i64), false)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64) != EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G2", argsCount: 1i64), true)
        @Expect(EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64) != EnumTypeInfo.get("upstream.EciGen<Int64>").getConstructor("G1", argsCount: 0i64), false)
    }

}

