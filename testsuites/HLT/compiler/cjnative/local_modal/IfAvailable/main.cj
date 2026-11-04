// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: @IfAvailable 融合用例共用主程序。
//   场景：应用由带 local-modal-SDK 编译，实际运行环境中 cangjie runtime 与标准库被下沉到内核（不含 local 特性）。
//   @IfAvailable(level: 19) 解糖出的运行期门控读取 DeviceInfo.sdkApiVersion（由运行环境提供，
//   本用例集以 ohos.device_info 动态库 mock 模拟）：>=19 进入 local 分支调用 cpu.computeLocal，
//   否则走 fallback 分支调用等价的 cpu.computeHeap。
//   同一份 main.cj + cpu.cj 编译出的同一个二进制要在两种运行环境间复用：
//   - ifavailable_local_env.cj：新 runtime/新标准库环境（sdkApiVersion=19）→ local 分支；
//   - ifavailable_kernel_compat.cj：内核下沉旧 runtime/旧标准库环境（sdkApiVersion=10）→ fallback 分支。

import ohos.device_info.DeviceInfo
import cpu.*

main(): Int64 {
    @IfAvailable(level: 19, { =>
        println("local branch: ${computeLocal()}")
    }, { =>
        println("fallback branch: ${computeHeap()}")
    })
    return 0
}
