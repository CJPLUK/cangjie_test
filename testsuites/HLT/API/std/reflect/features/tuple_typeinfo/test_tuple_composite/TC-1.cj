/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-1
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
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>().name, "Tuple<Array<Int64>, String>")
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>().qualifiedName.size > 0i64, true)
        @Expect[tupleSuperInterfacesHasAny](TupleTypeInfo.of<(Array<Int64>, String)>().superInterfaces, ["Any"])
        @Expect[tupleElements](TupleTypeInfo.of<(Array<Int64>, String)>().elements, ["Array<Int64>", "String"])
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>().hashCode() == TupleTypeInfo.of<(Array<Int64>, String)>().hashCode(), true)
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>().toString() != "", true)
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>() == TupleTypeInfo.of<(Array<Int64>, String)>(), true)
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>().isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect[emptyCollection](TupleTypeInfo.of<(Array<Int64>, String)>().instanceFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Array<Int64>, String)>().staticFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Array<Int64>, String)>().instanceProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Array<Int64>, String)>().staticProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Array<Int64>, String)>().modifiers, [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Array<Int64>, String)>().getInstanceFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of<(Array<Int64>, String)>().getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Array<Int64>, String)>().getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Array<Int64>, String)>().getStaticFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of<(Array<Int64>, String)>().getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Array<Int64>, String)>().getStaticProperty("anyFunction"))
        @Expect[anyValue](TupleTypeInfo.of<(Array<Int64>, String)>().construct([[1, 2], "b"]), ([1, 2], "b"))
        @Expect[tupleElementsList](TupleTypeInfo.of<(Array<Int64>, String)>().destruct(([1, 2], "b")), [[1, 2], "b"])
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>() != TupleTypeInfo.of(([1, 2], "b", "x")), true)
        @Expect(TupleTypeInfo.of<(Array<Int64>, String)>() == TupleTypeInfo.of(([1, 2], "b", "x")), false)
    }

}

