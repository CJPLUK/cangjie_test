/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-9
*- @TestCaseName: std.reflect — TupleTypeInfo (复合) — Tuple_tpl_3_point_nested_bool
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Tuple_tpl_3_point_nested_bool（typeVariant × acquisitionPath）
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
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).name, "Tuple<upstream.Point, Tuple<Int64, String>, Bool>")
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).qualifiedName.size > 0i64, true)
        @Expect[tupleSuperInterfacesHasAny](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).superInterfaces, ["Any"])
        @Expect[tupleElements](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).elements, ["Point", "Tuple<Int64, String>", "Bool"])
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).hashCode() == TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).hashCode(), true)
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).toString() != "", true)
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)) == TupleTypeInfo.of((Point(1, 2), (1, "a"), false)), true)
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect[emptyCollection](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).instanceFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).staticFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).instanceProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).staticProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).modifiers, [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).getInstanceFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).getStaticFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).getStaticProperty("anyFunction"))
        @Expect[anyValue](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).construct([Point(1, 2), (1, "a"), false]), (Point(1, 2), (1, "a"), false))
        @Expect[tupleElementsList](TupleTypeInfo.of((Point(1, 2), (1, "a"), false)).destruct((Point(1, 2), (1, "a"), false)), [Point(1, 2), (1, "a"), false])
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)) != TupleTypeInfo.of((Point(1, 2), (1, "a"), false, "x")), true)
        @Expect(TupleTypeInfo.of((Point(1, 2), (1, "a"), false)) == TupleTypeInfo.of((Point(1, 2), (1, "a"), false, "x")), false)
    }

}

