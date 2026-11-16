/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-PHY-0
*- @TestCaseName: std.reflect — StructTypeInfo physical — NonStructAcquisition
*- @TestCaseType: 功能测试
*- @Design Description: 取消豁免的物理验证：非struct获取/构造体throw封装/box-unbox 成员修改，预言全部来自 Rule
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*   -#被测类型的源文件已编译为动态库
*- @Brief: 描述测试步骤
*   -#按 Rule 预言逐条断言原豁免清单的可物化条目
*- @Expect: 用例的预期结果
*   -#断言结果与 Rule 预言一致（SDK 与文档不符处如实失败）
*- @Priority: P0
*/

// LEVEL: 0
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
class TestStruct {
    @TestCase
    func testCase0(): Unit {
        @Expect(StructTypeInfo.of(NotAStruct()).qualifiedName, "upstream.NotAStruct")
        @ExpectThrows[IllegalTypeException](StructTypeInfo.of<NotAStruct>())
    }

}

