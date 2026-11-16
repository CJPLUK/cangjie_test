/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * @TestCaseID: TC-AOP-PRIORITY-13
 * @TestCaseName: stdx.aspect_cj — priority: global_to_instance_param_mismatch_over_func_type_str_mismatch
 * @TestCaseType: 负面测试
 * @Design Description: 同一份代码有两处违规：ReplaceFuncBody 的 original 额外携带 receiver（如 (WovenStruct) -> Unit），以及 InsertAtEntry 的 funcTypeStr 与目标函数不一致。断言收集报错含切面函数类型不匹配
 * @Priority: P0
 * @Condition: 仓颉工具链及 stdx.aspect_cj 扩展库已安装
 * @Brief: 1. annotatedFunction 的 original 额外携带 receiver((WovenStruct) -> Unit）；aspectFtStr 的 funcTypeStr 为 (Bool)->Unit，与全局 wovenFunction 不一致
 * @Brief: 2. collect 阶段编译，断言报错锚为 original 类型不匹配
 * @Expect: 报错锚 = has function type
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

@InsertAtEntry[packageName: "AOP_demo1", className: "", methodName: "wovenFunction", isStatic: false, recursive: false,
    funcTypeStr: "(Bool)->Unit"]
public func aspectFtStr(x: Int64): Unit {
    println("annotatedFunction")
}

public struct WovenStruct {
    public func wovenFunction(): Unit {
        println("wovenFunction")
    }
}

public func wovenFunction(x: Int64): Int64 {
    println("wovenFunction")
    x + 1
}

main() {
    println("start")
    let w = WovenStruct()
    w.wovenFunction()
    let r = wovenFunction(42)
    println("end")
    0
}
