// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 模拟"内核下沉"环境提供的系统 API ohos.device_info。
//   device_info_10.cj 固定返回 10，且由旧版 SDK（OLD_CANGJIE_HOME）编译成动态库——
//   即内核自带旧工具链构建的系统 API：新 SDK 编译的应用必须能消费其 .cjo（import 解析）
//   与 .so（链接/加载）。运行期门控读到 10 < 19，level:19 的 local 分支落回 fallback。

package ohos.device_info

public class DeviceInfo {
    public static prop sdkApiVersion: Int64 {
        get() {10}
    }
}
