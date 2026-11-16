/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-7
*- @TestCaseName: std.reflect — TupleTypeInfo (复合) — Tuple_tpl_2_nested
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Tuple_tpl_2_nested（typeVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#元组为语言内建类型，无需上游自定义类型（Point 除外）
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 TupleTypeInfo
*   -#按 Rule 预言验证 elements/construct/destruct/name/继承面行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
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
import std.collection.*
import upstream.*
import utils.*
@Test
class TestTupleComposite {
    @TestCase
    func testCase0(): Unit {
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>().name, "Tuple<Tuple<Int64, String>, Bool>")
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>().qualifiedName.size > 0i64, true)
        @Expect[tupleSuperInterfacesHasAny](TupleTypeInfo.of<((Int64, String), Bool)>().superInterfaces, ["Any"])
        @Expect[tupleElements](TupleTypeInfo.of<((Int64, String), Bool)>().elements, ["Tuple<Int64, String>", "Bool"])
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>().hashCode() == TupleTypeInfo.of<((Int64, String), Bool)>().hashCode(), true)
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>().toString() != "", true)
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>() == TupleTypeInfo.of<((Int64, String), Bool)>(), true)
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>().isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect[emptyCollection](TupleTypeInfo.of<((Int64, String), Bool)>().instanceFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of<((Int64, String), Bool)>().staticFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of<((Int64, String), Bool)>().instanceProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of<((Int64, String), Bool)>().staticProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of<((Int64, String), Bool)>().modifiers, [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<((Int64, String), Bool)>().getInstanceFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of<((Int64, String), Bool)>().getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<((Int64, String), Bool)>().getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<((Int64, String), Bool)>().getStaticFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of<((Int64, String), Bool)>().getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<((Int64, String), Bool)>().getStaticProperty("anyFunction"))
        @Expect[anyValue](TupleTypeInfo.of<((Int64, String), Bool)>().construct([(1, "a"), true]), ((1, "a"), true))
        @Expect[tupleElementsList](TupleTypeInfo.of<((Int64, String), Bool)>().destruct(((1, "a"), true)), [(1, "a"), true])
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>() != TupleTypeInfo.of(((1, "a"), true, "x")), true)
        @Expect(TupleTypeInfo.of<((Int64, String), Bool)>() == TupleTypeInfo.of(((1, "a"), true, "x")), false)
    }

}

