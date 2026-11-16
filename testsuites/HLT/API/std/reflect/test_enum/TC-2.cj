/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-2
 * - @TestCaseName: std.reflect — EnumTypeInfo — PlainEnum
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证Plain enum with 6 constructors
 * - @Condition: 用例的预置条件
 *   -#仓颉工具链环境已正确安装
 *   -#被测类型的源文件已编译为动态库
 * - @Brief: 描述测试步骤
 *   -#获取TypeInfo引用（byName/byInstance/byTypeArg）
 *   -#通过TypeInfo查询被测类型的成员信息
 *   -#构造实例并读写成员变量/属性
 *   -#调用成员函数并验证返回值
 * - @Expect: 用例的预期结果
 *   -#所有@Expect断言通过，反射API返回值与预期一致
 * - @Priority: P0
 */

// LEVEL: 3
// Description:
// DEPENDENCE: ../utils upstream
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// (!target_ohos) EXEC: %compiler %cmp_opt %f -L . -lutils -lupstream -o %output %cmp_utest_opt
// (!target_ohos) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import utils.*
import upstream.*
import std.reflect.*

@Test
class TestEnum {
    @TestCase
    func testCase0(): Unit {
        @Expect(EnumTypeInfo.of<Enum>().name != "")
        @Expect(EnumTypeInfo.of<Enum>().constructors.toArray().size, 5i64)
        @Expect[anyValue](EnumTypeInfo.of<Enum>().getConstructor("A", argsCount: 0i64).apply([]), EnumTypeInfo.of<Enum>().getConstructor("A", argsCount: 0i64).apply([]))
        @Expect[anyValue](EnumTypeInfo.of<Enum>().getConstructor("B", argsCount: 3i64).apply([1i64, true, 114.514000f64]), EnumTypeInfo.of<Enum>().getConstructor("B", argsCount: 3i64).apply([1i64, true, 114.514000f64]))
        @Expect[anyValue](EnumTypeInfo.of<Enum>().getConstructor("C", argsCount: 3i64).apply([Struct(), Enum.A, Class()]), EnumTypeInfo.of<Enum>().getConstructor("C", argsCount: 3i64).apply([Struct(), Enum.A, Class()]))
        @Expect[anyValue](EnumTypeInfo.of<Enum>().getConstructor("D", argsCount: 1i64).apply([((), ())]), EnumTypeInfo.of<Enum>().getConstructor("D", argsCount: 1i64).apply([((), ())]))
        @Expect[anyValue](EnumTypeInfo.of<Enum>().getConstructor("E", argsCount: 1i64).apply([{p0: Int64 =>true
        }]), EnumTypeInfo.of<Enum>().getConstructor("E", argsCount: 1i64).apply([{p0: Int64 =>true
        }]))
        @Expect(EnumTypeInfo.of<Enum>().getConstructor("A", argsCount: 0i64).name, "A")
        @Expect(EnumTypeInfo.of<Enum>().getConstructor("B", argsCount: 3i64).name, "B")
        @Expect(EnumTypeInfo.of<Enum>().getConstructor("C", argsCount: 3i64).name, "C")
        @Expect(EnumTypeInfo.of<Enum>().getConstructor("D", argsCount: 1i64).name, "D")
        @Expect(EnumTypeInfo.of<Enum>().getConstructor("E", argsCount: 1i64).name, "E")
        @Expect(EnumTypeInfo.of<Enum>().annotations.toArray().size, 0i64)
        @Expect(EnumTypeInfo.of<Enum>().hashCode() == EnumTypeInfo.of<Enum>().hashCode())
        @Expect[anyValue](EnumTypeInfo.of<Enum>().toString(), EnumTypeInfo.of<Enum>().qualifiedName)
        @ExpectThrows[InfoNotFoundException](EnumTypeInfo.of<Enum>().construct("__NonExistentCtor__", []))
        @Expect(EnumTypeInfo.of<Enum>().constructors.size, 5i64)
    }
}
