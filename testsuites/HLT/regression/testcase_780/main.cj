/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// 用例: common/specific 编译 CJO 依赖信息导入顺序稳定性
// 意图: 固定同一条 Android arm32 specific 编译命令重复执行, 检查合并生成的
//       import_order_repro.cjo 是否保持字节一致。16 个 common 文件保留多个
//       隐式 std.core 导入节点, 已观察到依赖 JSON 中 imports 顺序出现不同的
//       排列; 若出现差异则编译器仍存在依赖信息顺序不稳定问题, 用例失败。
// 说明: 本用例不依赖 NDK/设备, 仅需要带 Android arm32 目标库及 LLVM 工具链
//       的 Cangjie SDK, 产物写入本目录 out/ 供失败后排查。

// LEVEL: 2
// DEPENDENCE: common platform tools
// (target_android) EXEC: %python tools/check_import_order.py --cangjie-home %cangjieDir --runs 100
// (target_android) ASSERT: scan PASS
