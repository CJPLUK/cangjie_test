/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-3
*- @TestCaseName: std.reflect — GenericTypeInfo (全局) — Global_zip
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Global_zip（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测泛型函数/持有类已编译进 upstream 动态库
*- @Brief: 描述测试步骤
*   -#通过宿主函数信息的 genericParams 拿到 GenericTypeInfo
*   -#按 Rule 预言验证 ==/!=/name/继承面/空集行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: upstream ../../../utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %f -L . -lupstream -lutils -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import std.collection.*
import upstream.*
import utils.*
@Test
class TestGtiGlobal {
    @TestCase
    func testCase0(): Unit {
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].name, "A")
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].qualifiedName.size > 0i64, true)
        @Expect[annotations](findGfunc("zip").genericParams.toArray()[0i64].annotations, [])
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].findAnnotation<Tag>().isNone(), true)
        @Expect[annotationsArray](findGfunc("zip").genericParams.toArray()[0i64].findAllAnnotations<Tag>(), [])
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].getAllAnnotations().toArray().size, 0i64)
        @Expect[emptyCollection](findGfunc("zip").genericParams.toArray()[0i64].modifiers, [])
        @ExpectThrows[InfoNotFoundException](findGfunc("zip").genericParams.toArray()[0i64].getInstanceFunction("anyFunction", []))
        @Expect[emptyCollection](findGfunc("zip").genericParams.toArray()[0i64].getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](findGfunc("zip").genericParams.toArray()[0i64].getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](findGfunc("zip").genericParams.toArray()[0i64].getStaticFunction("anyFunction", []))
        @Expect[emptyCollection](findGfunc("zip").genericParams.toArray()[0i64].getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](findGfunc("zip").genericParams.toArray()[0i64].getStaticProperty("anyFunction"))
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].hashCode() == findGfunc("zip").genericParams.toArray()[0i64].hashCode(), true)
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].toString() != "", true)
        @Expect(findGfunc("zip").genericParams.toArray()[0i64].isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect(findGfunc("zip").genericParams.toArray()[0i64] == findGfunc("zip").genericParams.toArray()[0i64], true)
        @Expect(!(findGfunc("zip").genericParams.toArray()[0i64] != findGfunc("zip").genericParams.toArray()[0i64]), true)
        @Expect(!(findGfunc("zip").genericParams.toArray()[0i64] == findGfunc("id").genericParams.toArray()[0i64]), true)
        @Expect(findGfunc("zip").genericParams.toArray()[0i64] != findGfunc("id").genericParams.toArray()[0i64], true)
        @Expect(findGfunc("zip").genericParams.toArray()[0i64] == PackageInfo.get("upstream").getFunction("zip", gtiSigArray("zip")).genericParams.toArray()[0i64], true)
        @Expect[genericParamNames](findGfunc("zip").genericParams, ["A", "B"])
    }

}

