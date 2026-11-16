/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-10
*- @TestCaseName: std.reflect — TupleTypeInfo (基础) — Tuple_tpl_4_i64_str_bool_f64
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Tuple_tpl_4_i64_str_bool_f64（typeVariant × acquisitionPath）
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
class TestTupleBasic {
    @TestCase
    func testCase0(): Unit {
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>().name, "Tuple<Int64, String, Bool, Float64>")
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>().qualifiedName.size > 0i64, true)
        @Expect[tupleSuperInterfacesHasAny](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().superInterfaces, ["Any"])
        @Expect[tupleElements](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().elements, ["Int64", "String", "Bool", "Float64"])
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>().hashCode() == TupleTypeInfo.of<(Int64, String, Bool, Float64)>().hashCode(), true)
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>().toString() != "", true)
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>() == TupleTypeInfo.of<(Int64, String, Bool, Float64)>(), true)
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>().isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect[emptyCollection](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().instanceFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().staticFunctions, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().instanceProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().staticProperties, [])
        @Expect[emptyCollection](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().modifiers, [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().getInstanceFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().getStaticFunction("anyFunction", []))
        @Expect[strArrayContent](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().getStaticProperty("anyFunction"))
        @Expect[anyValue](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().construct([1, "a", true, 3.14]), (1, "a", true, 3.14))
        @Expect[tupleElementsList](TupleTypeInfo.of<(Int64, String, Bool, Float64)>().destruct((1, "a", true, 3.14)), [1, "a", true, 3.14])
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>() != TupleTypeInfo.of((1, "a", true, 3.14, "x")), true)
        @Expect(TupleTypeInfo.of<(Int64, String, Bool, Float64)>() == TupleTypeInfo.of((1, "a", true, 3.14, "x")), false)
    }

}

