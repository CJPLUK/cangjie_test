/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
*- @TestCaseID: TC-2
*- @TestCaseName: std.reflect — PackageInfo (info) — Pkg_upstream.sub
*- @TestCaseType: 功能测试
*- @Design Description: Rule 驱动：combo Pkg_upstream.sub（packageVariant × acquisitionPath）
*- @Condition: 用例的预置条件
*   -#仓颉工具链环境已正确安装
*- @Brief: 描述测试步骤
*   -#通过获取路径拿到 PackageInfo
*   -#按 Rule 预言验证身份/层级/成员集合/查询/相等行为
*- @Expect: 用例的预期结果
*   -#所有@Expect断言通过，Rule 预期与官方 doc-libs 契约一致
*- @Priority: P0
*/

// LEVEL: 3
// Description:
// DEPENDENCE: upstream ../../../utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream/sub
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
class TestPkgInfo {
    @TestCase
    func testCase0(): Unit {
        @Expect(PackageInfo.get("upstream.sub").name, "sub")
        @Expect(PackageInfo.get("upstream.sub").qualifiedName, "upstream.sub")
        @Expect(PackageInfo.get("upstream.sub").organizationName, "")
        @Expect(PackageInfo.get("upstream.sub").version, "")
        @Expect(PackageInfo.get("upstream.sub").parentPackage.name, "upstream")
        @Expect(PackageInfo.get("upstream.sub").rootPackage.name, "upstream")
        @Expect[pkgSubPackages](PackageInfo.get("upstream.sub").subPackages, [])
        @Expect[pkgTypeInfos](PackageInfo.get("upstream.sub").typeInfos, ["SubHelper"])
        @Expect[pkgFunctions](PackageInfo.get("upstream.sub").functions, [])
        @Expect[pkgVariables](PackageInfo.get("upstream.sub").variables, [])
        @Expect(PackageInfo.get("upstream.sub").getTypeInfo("upstream.sub.SubHelper").name, "SubHelper")
        @Expect(PackageInfo.get("upstream.sub").hashCode() == PackageInfo.get("upstream.sub").hashCode(), true)
        @Expect(PackageInfo.get("upstream.sub").toString() == PackageInfo.get("upstream.sub").qualifiedName, true)
        @Expect(PackageInfo.get("upstream.sub") == PackageInfo.get("upstream.sub"), true)
        @Expect(!(PackageInfo.get("upstream.sub") != PackageInfo.get("upstream.sub")), true)
        @Expect(!(PackageInfo.get("upstream.sub") == PackageInfo.get("default")), true)
        @Expect(PackageInfo.get("upstream.sub") != PackageInfo.get("default"), true)
    }

}

