// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: 模拟"运行环境/内核"提供的系统 API ohos.device_info（动态库形式随环境替换）。
//   device_info_19.cj 固定返回 19，配合 ifavailable_local_env.cj：
//   运行期门控读到 19 >= 19，放行 level:19 的 local 分支。

package ohos.device_info

public class DeviceInfo {
    public static prop sdkApiVersion: Int64 {
        get() {19}
    }
}
