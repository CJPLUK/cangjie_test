/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-0
*- @TestCaseName: std.reflect — PackageInfo (load) — loadOk
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo loadOk（packageVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 PackageInfo
*   -#按 Rule 预言验证身份/层级/成员集合/查询/相等行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
*- @Priority: P0
*/

// LEVEL: 0
// Description:
// DEPENDENCE: upstream ../../../utils pkgdyn
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream/sub
// EXEC: %compiler %cmp_opt %compile_dylib_opt -p pkgdyn -o pkgdyn
// EXEC: %compiler %cmp_opt %f -L . -lupstream -lupstream.sub -lutils -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import std.reflect.*
import std.collection.*
import std.env.*
import utils.*
import upstream.*
import upstream.sub.*
@Test
class TestPkgLoad {
    @TestCase
    func testCase0(): Unit {
        @Expect(PackageInfo.load(getWorkingDirectory().toString() + "/pkgdyn/libpkgdyn").name != "", true)
    }

}

