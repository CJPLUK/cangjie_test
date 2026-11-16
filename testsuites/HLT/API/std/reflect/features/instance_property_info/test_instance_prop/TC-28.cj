/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-28
*- @TestCaseName: std.reflect — InstancePropertyInfo — OpenPropClass × valid × fromGetInstanceProperty
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
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").name, "hook")
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").modifiers.toArray().size, 1i64)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").toString(), "open prop hook: Int64")
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").hashCode() == ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").isOpen(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").findAllAnnotations<PropAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").findAnnotation<PropAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").getAllAnnotations().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").getValue(OpenPropShape())).name == "Int64")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook").setValue(OpenPropShape(), 100i64))
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").name, "plain")
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").typeInfo.name, "Int64")
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").modifiers.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").annotations.toArray().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").toString(), "prop plain: Int64")
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").hashCode() == ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").hashCode(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").isAbstract(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").isMutable(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").isOpen(), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").findAllAnnotations<PropAnnotation>().size, 0i64)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").findAnnotation<PropAnnotation>().isNone(), true)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").getAllAnnotations().size, 0i64)
        @Expect(TypeInfo.of(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").getValue(OpenPropShape())).name == "Int64")
        @ExpectThrows[IllegalSetException](ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain").setValue(OpenPropShape(), 100i64))
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook") == ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook"), true)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook") != ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook"), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook") == ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain"), false)
        @Expect(ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("hook") != ClassTypeInfo.get("upstream.OpenPropShape").getInstanceProperty("plain"), true)
    }

}

