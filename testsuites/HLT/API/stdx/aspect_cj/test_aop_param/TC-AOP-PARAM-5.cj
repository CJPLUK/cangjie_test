/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * @TestCaseID: TC-AOP-PARAM-5
 * @TestCaseName: stdx.aspect_cj — @InsertAtExit × (String)->String
 * @TestCaseType: 功能测试
 * @Design Description: EC 等价类：切面函数形参列表与被织入函数源码形参一致（ReplaceFuncBody 加原始闭包；funcTypeStr 不含隐式 receiver）
 * @Priority: P0
 * @Condition: 仓颉工具链及 stdx.aspect_cj 扩展库已安装
 * @Brief: 1. 声明形参适配 (String)->String 被织入函数的 @InsertAtExit 切面函数
 * @Brief: 2. main() 按 start→调用→(打印返回值)→end 驱动
 * @Brief: 3. 两阶段编译后运行，验证 stdout 顺序与返回值
 * @Expect: stdout 顺序符合织入语义；返回值正确
 */
// LEVEL: 1
// EXEC: %compiler %import-cangjie-stdx -lstdx.aspect_cj %cmp_opt %f -o %output --plugin=%host-cangjie-dynamic-stdx-path/libstdx.collect_aspects.%host_dylib_suffix
// EXEC: %compiler %import-cangjie-stdx -lstdx.aspect_cj %cmp_opt %f -o %output --plugin=%host-cangjie-dynamic-stdx-path/libstdx.weave_aspects.%host_dylib_suffix
// RUN-EXEC: %run_stdx %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan start\nwovenFunction\nannotatedFunction\nhello\nend

package AOP_demo1

import stdx.aspect_cj.*

@InsertAtExit[packageName: "AOP_demo1", className: "", methodName: "wovenFunction", isStatic: false, recursive: false,
    funcTypeStr: "(std.core.String)->std.core.String"]
public func annotatedFunction(s: String): Unit {
    println("annotatedFunction")
}

public func wovenFunction(s: String): String {
    println("wovenFunction")
    s
}

main() {
    println("start")
    let r = wovenFunction("hello")
    println(r)
    println("end")
    0
}
