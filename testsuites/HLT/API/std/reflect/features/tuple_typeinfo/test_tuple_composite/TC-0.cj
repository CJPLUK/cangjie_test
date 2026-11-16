/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — TupleTypeInfo (复合) — Tuple_tpl_2_arr_i64_str
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Tuple_tpl_2_arr_i64_str（typeVariant × acquisitionPath）
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
import std.collection.*
import upstream.*
import utils.*
@Test
class TestTupleComposite {
    @TestCase
    func testCase0(): Unit {
        @Expect(TupleTypeInfo.of(([1, 2], "b")).name, "Tuple<Array<Int64>, String>")
        @Expect(TupleTypeInfo.of(([1, 2], "b")).qualifiedName.size > 0i64, true)
        @Expect[tupleSuperInterfacesHasAny](TupleTypeInfo.of(([1, 2], "b")).superInterfaces, ["Any"])
        @Expect[tupleElements](TupleTypeInfo.of(([1, 2], "b")).elements, ["Array<Int64>", "String"])
        @Expect(TupleTypeInfo.of(([1, 2], "b")).hashCode() == TupleTypeInfo.of(([1, 2], "b")).hashCode(), true)
        @Expect(TupleTypeInfo.of(([1, 2], "b")).toString() != "", true)
        @Expect(TupleTypeInfo.of(([1, 2], "b")) == TupleTypeInfo.of(([1, 2], "b")), true)
        @Expect(TupleTypeInfo.of(([1, 2], "b")).isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect[emptyCollection](TupleTypeInfo.of(([1, 2], "b")).instanceFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of(([1, 2], "b")).staticFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of(([1, 2], "b")).instanceProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of(([1, 2], "b")).staticProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of(([1, 2], "b")).modifiers, [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of(([1, 2], "b")).getInstanceFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of(([1, 2], "b")).getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of(([1, 2], "b")).getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of(([1, 2], "b")).getStaticFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of(([1, 2], "b")).getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of(([1, 2], "b")).getStaticProperty("anyFunction"))
        @Expect[anyValue](TupleTypeInfo.of(([1, 2], "b")).construct([[1, 2], "b"]), ([1, 2], "b"))
        @Expect[tupleElementsList](TupleTypeInfo.of(([1, 2], "b")).destruct(([1, 2], "b")), [[1, 2], "b"])
        @Expect(TupleTypeInfo.of(([1, 2], "b")) != TupleTypeInfo.of(([1, 2], "b", "x")), true)
        @Expect(TupleTypeInfo.of(([1, 2], "b")) == TupleTypeInfo.of(([1, 2], "b", "x")), false)
    }

}

