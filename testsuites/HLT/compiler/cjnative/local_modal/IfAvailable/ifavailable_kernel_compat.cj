// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// [看护点]: "cangjie runtime 及标准库下沉到内核"场景的融合看护。
//   1) 应用（main.cj + cpu.cj，含 local 分支）只由带 local modal 特性的 SDK 编译一次；
//   2) 内核环境由旧 SDK 构成：旧 libcangjie-runtime.so + 旧 libcangjie-std-core.so
//      （均不含 local 特性）+ 旧 SDK 编译的系统 API mock（device_info_10.cj，sdkApiVersion=10）。
//      local-modal SDK 编译的应用必须能消费旧 SDK 产出的 .cjo/.so（内核自带旧工具链构建的系统 API）；
//   3) 同一二进制加载进内核环境时必须成功：local 分支引用的 CJ_MCC_*Local* 运行时符号
//      在旧 runtime 中缺失，依赖动态链接懒解析保证未进入的分支不被解析、不阻断加载；
//   4) 运行期门控读到 10 < 19，compute 必须走 fallback 分支（等价的非 local 实现，
//      输出 "fallback branch: 102"），且全程不得出现 local 分支输出——若出现，
//      说明门控失效导致旧环境执行了 local-mode 代码路径。
//   与 ifavailable_local_env.cj 共用同一份 main.cj/cpu.cj，构成同一二进制在两种运行环境间的行为镜像。

// LEVEL: 0
// (target_linux) DEPENDENCE: main.cj cpu.cj device_info_10.cj
// (target_linux) EXEC: %compiler %local %cmp_opt device_info_10.cj %compile_dylib_opt -o libohos.device_info.%dylib_suffix
// (target_linux) EXEC: %compiler %local %cmp_opt cpu.cj %compile_lib_opt -o cpu.a
// (target_linux) EXEC: %compiler %local %cmp_opt main.cj cpu.cjo cpu.a -L. -lohos.device_info -o %output
// (target_linux) RUN-EXEC: %run %run_opt %output %run_args 2>&1 | compare %f
// (target_linux) ASSERT: scan fallback branch: 102
// (target_linux) ASSERT: scan-not local branch
