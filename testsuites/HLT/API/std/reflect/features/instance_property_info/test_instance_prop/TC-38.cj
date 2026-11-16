/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-38
*- @TestCaseName: std.reflect — InstancePropertyInfo — AbstractPropClass × valid × fromGetInstanceProperty
*- @TestCaseType: 功能测试
*- @Design Description: 基于反射API等价类划分方法，消费 Rule 预言，验证 InstancePropertyInfo 反射行为
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#获取 InstancePropertyInfo 引用（getInstanceProperty / instanceProperties）
*   -#通过 Rule 预言验证 name/typeInfo/modifiers/annotations/getValue/setValue/相等性 的返回结果或异常路径
*- @Expect: 用例的预期结果
*   -#所有@Expect/@ExpectThrows断言通过，反射API返回值/异常与Rule预言一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: ../../../utils upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %f -L . -lutils -lupstream -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import utils.*
import upstream.*
import std.reflect.*
@Test
class TestInstanceProp {
    @TestCase
    func testCase0(): Unit {
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").name, "property1")
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").toString(), "prop property1: Int64")
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").hashCode() == ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").findAllAnnotations<PropAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").findAnnotation<PropAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1").getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").name, "property2")
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").modifiers.toArray().size, 2i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").toString(), "open abstract prop property2: Int64")
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").hashCode() == ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").isAbstract(), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").isOpen(), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").findAllAnnotations<PropAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").findAnnotation<PropAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2").getAllAnnotations().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1") == ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1"), true)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1") != ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1"), false)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1") == ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2"), false)
        @Expect(ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property1") != ClassTypeInfo.get("upstream.AbstractPropShape").getInstanceProperty("property2"), true)
    }

}

