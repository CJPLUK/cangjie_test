/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-5
*- @TestCaseName: std.reflect — TupleTypeInfo (复合) — Tuple_tpl_2_i64_point
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Tuple_tpl_2_i64_point（typeVariant × acquisitionPath）
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
        @Expect(TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName).toString().size > 0i64, true)
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().name, "Tuple<Int64, upstream.Point>")
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().qualifiedName.size > 0i64, true)
        @Expect[tupleSuperInterfacesHasAny]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().superInterfaces, ["Any"])
        @Expect[tupleElements]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().elements, ["Int64", "Point"])
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().hashCode() == (TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().hashCode(), true)
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().toString() != "", true)
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow() == (TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow(), true)
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().isSubtypeOf(InterfaceTypeInfo.get("Any")), true)
        @Expect[emptyCollection]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().instanceFunctions, [])
        @Expect[emptyCollection]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().staticFunctions, [])
        @Expect[emptyCollection]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().instanceProperties, [])
        @Expect[emptyCollection]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().staticProperties, [])
        @Expect[emptyCollection]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().modifiers, [])
        @ExpectThrows[InfoNotFoundException]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().getInstanceFunction("anyFunction", []))
        @Expect[strArrayContent]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().getInstanceFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().getInstanceProperty("anyFunction"))
        @ExpectThrows[InfoNotFoundException]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().getStaticFunction("anyFunction", []))
        @Expect[strArrayContent]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().getStaticFunctions("anyFunction"), [])
        @ExpectThrows[InfoNotFoundException]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().getStaticProperty("anyFunction"))
        @Expect[anyValue]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().construct([1, Point(10, 20)]), (1, Point(10, 20)))
        @Expect[tupleElementsList]((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow().destruct((1, Point(10, 20))), [1, Point(10, 20)])
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow() != TupleTypeInfo.of((1, Point(10, 20), "x")), true)
        @Expect((TypeInfo.get(TupleTypeInfo.of((1, Point(10, 20))).qualifiedName) as TupleTypeInfo).getOrThrow() == TupleTypeInfo.of((1, Point(10, 20), "x")), false)
    }

}

