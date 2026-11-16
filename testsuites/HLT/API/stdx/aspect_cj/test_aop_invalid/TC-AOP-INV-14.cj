/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * @TestCaseID: TC-AOP-INV-14
 * @TestCaseName: stdx.aspect_cj — invalid: global_to_instance_param_mismatch
 * @TestCaseType: 负面测试
 * @Design Description: 全局形态切面带 receiver（self）形参织入实例成员函数，original 闭包额外携带 receiver（如 (WovenStruct) -> Unit），报切面函数类型不匹配
 * @Priority: P0
 * @Condition: 仓颉工具链及 stdx.aspect_cj 扩展库已安装
 * @Brief: 1. 构造违规：全局形态切面带 receiver（self）形参织入实例成员函数，original 闭包额外携带 receiver（如 (WovenStruct) -> Unit），报切面函数类型不匹配
 * @Brief: 2. collect 阶段编译失败，断言报错锚
 * @Expect: 编译报错含「has function type」
 */
// LEVEL: 2
// EXEC-PIPE-1: %compiler %import-cangjie-stdx -lstdx.aspect_cj %cmp_opt %f -o %output --plugin=%host-cangjie-dynamic-stdx-path/libstdx.collect_aspects.%host_dylib_suffix 2>&1 | compare %f
// ASSERT: scan has function type
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

package AOP_demo1

import stdx.aspect_cj.*

@ReplaceFuncBody[packageName: "AOP_demo1", className: "WovenStruct", methodName: "wovenFunction", isStatic: false,
    recursive: false]
public func annotatedFunction(self: WovenStruct, original: (WovenStruct) -> Unit): Unit {
    println("annotatedFunction")
}

public struct WovenStruct {
    public func wovenFunction(): Unit {
        println("wovenFunction")
    }
}

main() {
    println("start")
    let w = WovenStruct()
    w.wovenFunction()
    println("end")
    0
}
